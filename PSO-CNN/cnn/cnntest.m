function [mmy,er, bad] = cnntest(net, x, y,opts)
    %  feedforward
    num=opts.sizepar+1;
    net.par{num}=net.gbestpar;
    net = cnnassign(net,num);
    net = cnnff(net,x,y,num); % 前向传播得到输出
    mmy = [];
    mmy =[mmy;net.fv];
	% [Y,I] = max(X) returns the indices of the maximum values in vector I
    [~, h] = max(net.o); % 找到最大的输出对应的标签
    [~, a] = max(y); 	 % 找到最大的期望输出对应的索引
    bad = find(h ~= a);  % 找到他们不相同的个数，也就是错误的次数

    er = numel(bad) / size(y, 2); % 计算错误率
end
