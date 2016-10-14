function net=cnnupdate_clpso(net,i,opts)


%%  ���弫ֵ��Ⱥ�弫ֵ
for num=1:opts.sizepar
    %���弫ֵ����
    if net.fitness(num)<net.fitnesspbest(num)
        net.fitnesspbest(num)=net.fitness(num);
        net.pbestpar{num}=net.par{num};
        net.flag(num)=0;
        
        %Ⱥ�弫ֵ����
        if net.fitness(num)<net.fitnessgbest
            net.fitnessgbest=net.fitness(num);
            net.gbestpar=net.par{num};
        end
        
    else
        net.flag(num)=net.flag(num)+1;
    end
end

%% �������ӵ��ٶ�λ��
% %�趨�߽�ֵ
% velmax=10;
% velmin=-10;
% parmax=5;
% parmin=-5;

for num=1:opts.sizepar
    net.Pc(num)=0.05+0.45*(exp(10*(num-1)/(opts.sizepar-1))-1)/(exp(10)-1);%�μ�clpso���¹�ʽ10
    
    if(net.flag(num)>=opts.m)
        %ʵ��ѡ�����ӵĹ���
        for d=1:size(net.par{num})
            if rand>net.Pc(num)
                net.pbestpar{num}(d)=net.pbestpar{num}(d);
            else
                f1=ceil(rand*opts.sizepar); f2=ceil(rand*opts.sizepar);
                if net.fitnesspbest(f1)>net.fitnesspbest(f2)
                    net.pbestpar{num}(d)=net.pbestpar{f1}(d);
                else
                    net.pbestpar{num}(d)=net.pbestpar{f2}(d);
                end
            end
        end
        net.flag(num)=0;
    end
    %�ٶȸ���
    opts.w(i)=opts.w0+(opts.w1-opts.w0)*i/opts.numepochs;
    rand_D=rand(size(net.par{num})); %�趨rand_Dʹÿһά�в�ͬ��rand
    %�ٶȸ���
    net.vel{num} = opts.w(i)*net.vel{num} + opts.c*rand_D.*(net.pbestpar{num}-net.par{num});%�õ��ʹ�ڲ�Ԫ�ػ���
    
    %��Ҫ����vel�����ֵ
    %      net.vel{num}(net.vel{num}>velmax)=velmax;
    %      net.vel{num}(net.vel{num}<velmin)=velmin;
    
    %����λ�ø���
    net.par{num}=net.par{num}+net.vel{num};
    % ����Ӧ���죬��Ҫ����λ�õ����ֵ
    total=numel(net.par{num});
    pos=unidrnd(total,1,floor(total/21));
    if rand>0.95
        net.par{num}(pos)=5*rands(1);
    end
      
end


%��ȫ���������Ӹ�����31������
net.par{opts.sizepar+1}=net.gbestpar;