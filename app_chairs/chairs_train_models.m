%%
%% MultiPIE face data
%%

% datadir='~/resultsets/gentrans3/20180713/chairs/data/';
datadir='~/resultsets/gentrans3/20180725/chairs/data/';

%%

load([datadir 'ds.mat']);

%%

% resdir='~/resultsets/gentrans3/20180713/chairs/';
resdir='~/resultsets/gentrans3/20180725/chairs/';

%%

mkdir(resdir);

%%

fetcher1=@(sz)chairs_fetch_batch(ds,sz,1,ds.train_ids);
fetcher5=@(sz)chairs_fetch_batch(ds,sz,5,ds.train_ids);

%% MLVAE, arch 1

net=create_net(1);
net=learn_net(net,[],'TolX',1e-4,'maxIter',30001,'save_dir',[resdir 'chairs_arch1_mlvae'],'batchSize',100,'save_interval',1000,'deterministic',false,'averaging',false,'gpu',true,'batchSplit',10,'fetcher',fetcher5);

%% GVAE, arch 1

net=create_net(1);
net=learn_net(net,[],'TolX',1e-4,'maxIter',30001,'save_dir',[resdir 'chairs_arch1_gvae'],'batchSize',100,'save_interval',1000,'deterministic',false,'averaging',true,'gpu',true,'batchSplit',10,'fetcher',fetcher5);

%% VAE, arch 1

net=create_net(1);
net=learn_net(net,[],'TolX',1e-4,'maxIter',30001,'save_dir',[resdir 'chairs_arch1_vae'],'batchSize',100,'save_interval',1000,'deterministic',false,'averaging',false,'gpu',true,'batchSplit',10,'fetcher',fetcher1);

%% MLVAE, arch 1, inst 2

net=create_net(1);
net=learn_net(net,[],'TolX',1e-4,'maxIter',30001,'save_dir',[resdir 'chairs_arch1_mlvae_inst2'],'batchSize',100,'save_interval',1000,'deterministic',false,'averaging',false,'gpu',true,'batchSplit',10,'fetcher',fetcher5);

%% MLVAE, arch 1, inst 3

net=create_net(1);
net=learn_net(net,[],'TolX',1e-4,'maxIter',30001,'save_dir',[resdir 'chairs_arch1_mlvae_inst3'],'batchSize',100,'save_interval',1000,'deterministic',false,'averaging',false,'gpu',true,'batchSplit',10,'fetcher',fetcher5);

%% GVAE, arch 1, inst 2

net=create_net(1);
net=learn_net(net,[],'TolX',1e-4,'maxIter',30001,'save_dir',[resdir 'chairs_arch1_gvae_inst2'],'batchSize',100,'save_interval',1000,'deterministic',false,'averaging',true,'gpu',true,'batchSplit',10,'fetcher',fetcher5);

%% GVAE, arch 1, inst 3

net=create_net(1);
net=learn_net(net,[],'TolX',1e-4,'maxIter',30001,'save_dir',[resdir 'chairs_arch1_gvae_inst3'],'batchSize',100,'save_interval',1000,'deterministic',false,'averaging',true,'gpu',true,'batchSplit',10,'fetcher',fetcher5);

%% VAE, arch 1, inst 2

net=create_net(1);
net=learn_net(net,[],'TolX',1e-4,'maxIter',30001,'save_dir',[resdir 'chairs_arch1_vae_inst2'],'batchSize',100,'save_interval',1000,'deterministic',false,'averaging',false,'gpu',true,'batchSplit',10,'fetcher',fetcher1);

%% VAE, arch 1, inst 3

net=create_net(1);
net=learn_net(net,[],'TolX',1e-4,'maxIter',30001,'save_dir',[resdir 'chairs_arch1_vae_inst3'],'batchSize',100,'save_interval',1000,'deterministic',false,'averaging',false,'gpu',true,'batchSplit',10,'fetcher',fetcher1);

%% loading 

nets=load_nets([resdir 'chairs_arch1_gvae'],'skip',5);
net=nets{end};

%%

nets=load_nets([resdir 'chairs_arch1_gvae'],'last',true);
net=nets{end};

%%

nets=load_nets([resdir 'gvae2'],'last',true);
net=nets{end};

%% displaying

nshow1=7; nshow2=6;
figure('position',[0 0 1200 600]);

for I=1:length(nets)
% for I=length(nets):length(nets)
    net=nets{I};
    
    subplot(1,2,1);
    x=make_swapping(net,ds,ds.train_rand_idx(1:nshow1),ds.train_rand_idx(end:-1:end-nshow2+1),'neg',true);
    montage(reshape(x,ds.wid+2,ds.wid+2,3,[])/6+0.7,'size',[nshow2+1 nshow1+1]);

    subplot(1,2,2);
    x=make_swapping(net,ds,ds.test_rand_idx(1:nshow1),ds.test_rand_idx(end:-1:end-nshow2+1),'neg',true);
    montage(reshape(x,ds.wid+2,ds.wid+2,3,[])/6+0.7,'size',[nshow2+1 nshow1+1]);

    title(net.file_name);
    pause(0.2);
end

%%

nshow1=7; nshow2=6;

figure('position',[0 0 800 400]);
subplot(1,2,1);
x=make_comparison_gt(net,ds,ds.train_rand_idx(1:nshow1),ds.train_rand_idx(end:-1:end-nshow1+1),@chairs_find_gt,'neg',true);
img=montage(reshape(x,ds.wid+2,ds.wid+2,3,[])/6+0.7,'size',[2 nshow1]);

subplot(1,2,2);
x=make_comparison_gt(net,ds,ds.test_rand_idx(1:nshow1),ds.test_rand_idx(end:-1:end-nshow1+1),@chairs_find_gt,'neg',true);
img=montage(reshape(x,ds.wid+2,ds.wid+2,3,[])/6+0.7,'size',[2 nshow1]);


%%

figure;
show1=12; show2=16;
x=make_interpolation(net,ds,ds.train_rand_idx(show1),ds.train_rand_idx(show2),0:1/3:1,-0.25:0.25:1.25,'neg',true);
img=montage(reshape(x,ds.wid+2,ds.wid+2,ds.dep,[])/6+0.7,'size',[4 7]);

%%

figure;
show1=11; show2=12;
x=make_interpolation(net,ds,ds.test_rand_idx(show1),ds.test_rand_idx(show2),0:1/3:1,-0.25:0.25:1.25,'neg',true);
img=montage(reshape(x,ds.wid+2,ds.wid+2,ds.dep,[])/6+0.7,'size',[4 7]);

%%



