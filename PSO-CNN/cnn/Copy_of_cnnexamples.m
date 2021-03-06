clear all; close all; clc;
addpath('C:\Users\Administrator\Desktop\dingjianping\paper_code\PSO-CNN\data');
addpath('C:\Users\Administrator\Desktop\dingjianping\paper_code\PSO-CNN\util');
load data512newb48;

% %归一化
% train_x=mapminmax(double(resshap(train_x)));
% test_x=mapminmax(double(test_x(:)'));


train_x = double(reshape(train_x',48,48,596))/255;
test_x = double(reshape(test_x',48,48,501))/255;
train_y = double(train_y');
test_y = double(test_y');

%% ex1 
%will run 1 epoch in about 200 second and get around 11% error. 
%With 100 epochs you'll get around 1.2% error

   % disp([num2str(i) '/' num2str(j)]);

cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 8, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize',3) %convolution layer
    struct('type', 's', 'scale', 2) %subsampling layer
    struct('type', 'c', 'outputmaps',16, 'kernelsize',3) %convolution layer
    struct('type', 's', 'scale', 2) %sub sampling layer
};

% clpso的参数初始化
% opts.w0=0.9;
% opts.w1=0.4;
% opts.c=1.49445;

% 标准PSO的参数
opts.w=0.6;
opts.c1=1.7;
opts.c2=1.7;

opts.sizepar=30;%sizepar为粒子群的数量
opts.m=3; % refreshing map 设为7，参见clpso论文 E Adjusting the Refreshing gap m
%设定边界值
opts.velmax=0.3;
opts.velmin=-0.3; %见pso综述，速度按经验一般取解空间的10%到20%
opts.parmax=1.5;  %见第40次实验，所有结果都在-1.5到1.5内
opts.parmin=-1.5;

cnn.Pc=zeros(1,opts.sizepar); %更新时使用的pc（i）
cnn.flag=zeros(1,opts.sizepar); %对于每一个粒子的判断flag，存在cnn的结构中能够保存下来

% 学习率
opts.alpha = 1;
% 每次挑出一个batchsize的batch来训练，也就是每用batchsize个样本就调整一次权值，而不是
% 把所有样本都输入了，计算所有样本的误差了才调整一次权值
opts.batchsize = 4; 

%循环迭代次数
opts.numepochs = 600;


cnn.par=cell(1,opts.sizepar+1);
cnn.vel=cell(1,opts.sizepar);
% 这里把cnn的设置给cnnsetup，它会据此构建一个完整的CNN网络，并返回
cnn = cnnsetup(cnn, train_x, train_y,opts);
% cnn = cnnsetup_original(cnn, train_x, train_y);
% 然后开始把训练样本给它，开始训练这个CNN网络
% cnn = cnntrain_clpso(cnn, train_x, train_y, opts );
cnn = cnntrain_v_sgd2(cnn, train_x, train_y, opts );

% 然后就用测试样本来测试
[mmy, er, bad] = cnntest(cnn, test_x, test_y,opts);
% [mmy, er, bad] = cnntest_original(cnn, test_x, test_y);

%比较变量间相似度，值越大，对应的越相似
compare=compare_cnn(cnn,opts);
    
save PSOCNN_48_54 cnn opts compare;

%show test error
disp([num2str(er*100) '% error']);
