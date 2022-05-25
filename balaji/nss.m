clear all; clc; close all;

[xx, fs] = wavread('C5_2_y.wav');           % 读入数据文件
xx=xx-mean(xx);                         % 消除直流分量
x=xx/max(abs(xx));                      % 幅值归一化

IS=0.25;                                % 设置前导无话段长度
wlen=200;                               % 设置帧长为25ms
inc=80;                                 % 设置帧移为10ms
SNR=5;                                  % 设置信噪比SNR
N=length(x);                            % 信号长度
time=(0:N-1)/fs;                        % 设置时间

signal=awgn(x,SNR,'measured','db');               % 叠加噪声
snr1=SNR_Calc(x,signal);            % 计算初始信噪比
NIS=fix((IS*fs-wlen)/inc +1);           % 求前导无话段帧数

a=4; b=0.001;                           % 设置参数a和b
output=SpectralSub(signal,wlen,inc,NIS,a,b);% 谱减
snr2=SNR_Calc(x,output);            % 计算谱减后的信噪比
snr=snr2-snr1;
fprintf('snr1=%5.4f   snr2=%5.4f   snr=%5.4f\n',snr1,snr2,snr);
unction frameout=enframe(x,win,inc)

nx=length(x(:));            % 取数据长度
nwin=length(win);           % 取窗长
if (nwin == 1)              % 判断窗长是否为1，若为1，即表示没有设窗函数
   len = win;               % 是，帧长=win
else
   len = nwin;              % 否，帧长=窗长
end
if (nargin < 3)             % 如果只有两个参数，设帧inc=帧长
   inc = len;
end
nf = fix((nx-len+inc)/inc); % 计算帧数
frameout=zeros(nf,len);            % 初始化
indf= inc*(0:(nf-1)).';     % 设置每帧在x中的位移量位置
inds = (1:len);             % 每帧数据对应1:len
frameout(:) = x(indf(:,ones(1,len))+inds(ones(nf,1),:));   % 对数据分帧
if (nwin > 1)               % 若参数中包括窗函数，把每帧乘以窗函数
    w = win(:)';            % 把win转成行数据
    function frameout=filpframe(x,win,inc)

[nf,len]=size(x);
nx=(nf-1) *inc+len;                 %原信号长度
frameout=zeros(nx,1);
nwin=length(win);                   % 取窗长
if (nwin ~= 1)                           % 判断窗长是否为1，若为1，即表示没有设窗函数
    winx=repmat(win',nf,1);
    x=x./winx;                          % 除去加窗的影响
    x(find(isinf(x)))=0;                %去除除0得到的Inf
end