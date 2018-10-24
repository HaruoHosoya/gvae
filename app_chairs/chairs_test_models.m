%%
%% Chairs 
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

mkdir([resdir 'results']);

%% analyzing

nets=load_nets([resdir 'chairs_arch1_gvae'],'last',true); net=nets{end};
net=chairs_analyze_model(net,ds);
save([resdir 'results/chairs_arch1_gvae.mat'],'net');

%%

nets=load_nets([resdir 'chairs_arch1_mlvae'],'last',true); net=nets{end};
net=chairs_analyze_model(net,ds);
save([resdir 'results/chairs_arch1_mlvae.mat'],'net');

%%

nets=load_nets([resdir 'chairs_arch1_vae'],'last',true); net=nets{end};
net=chairs_analyze_model(net,ds);
save([resdir 'results/chairs_arch1_vae.mat'],'net');

%%

nets=load_nets([resdir 'chairs_arch1_gvae_inst2'],'last',true); net=nets{end};
net=chairs_analyze_model(net,ds);
save([resdir 'results/chairs_arch1_gvae_inst2.mat'],'net');

%%

nets=load_nets([resdir 'chairs_arch1_mlvae_inst2'],'last',true); net=nets{end};
net=chairs_analyze_model(net,ds);
save([resdir 'results/chairs_arch1_mlvae_inst2.mat'],'net');

%%

nets=load_nets([resdir 'chairs_arch1_vae_inst2'],'last',true); net=nets{end};
net=chairs_analyze_model(net,ds);
save([resdir 'results/chairs_arch1_vae_inst2.mat'],'net');

%%

nets=load_nets([resdir 'chairs_arch1_gvae_inst3'],'last',true); net=nets{end};
net=chairs_analyze_model(net,ds);
save([resdir 'results/chairs_arch1_gvae_inst3.mat'],'net');

%%

nets=load_nets([resdir 'chairs_arch1_mlvae_inst3'],'last',true); net=nets{end};
net=chairs_analyze_model(net,ds);
save([resdir 'results/chairs_arch1_mlvae_inst3.mat'],'net');

%%

nets=load_nets([resdir 'chairs_arch1_vae_inst3'],'last',true); net=nets{end};
net=chairs_analyze_model(net,ds);
save([resdir 'results/chairs_arch1_vae_inst3.mat'],'net');

%%
%%
%%

mkdir([resdir '/figs']);

%%

figure;

load([resdir 'results/chairs_arch1_vae.mat']);
errorbar(net.nshot,mean(net.nshot_sucrate,2),std(net.nshot_sucrate,[],2),'g');
hold on;

load([resdir 'results/chairs_arch1_gvae.mat']);
errorbar(net.nshot,mean(net.nshot_sucrate,2),std(net.nshot_sucrate,[],2),'r');
hold on;
load([resdir 'results/chairs_arch1_mlvae.mat']);
errorbar(net.nshot,mean(net.nshot_sucrate,2),std(net.nshot_sucrate,[],2),'b');
hold on;
load([resdir 'results/chairs_arch1_gvae_inst2.mat']);
errorbar(net.nshot,mean(net.nshot_sucrate,2),std(net.nshot_sucrate,[],2),'r');
hold on;
load([resdir 'results/chairs_arch1_mlvae_inst2.mat']);
errorbar(net.nshot,mean(net.nshot_sucrate,2),std(net.nshot_sucrate,[],2),'b');
hold on;
load([resdir 'results/chairs_arch1_vae_inst2.mat']);
errorbar(net.nshot,mean(net.nshot_sucrate,2),std(net.nshot_sucrate,[],2),'g');
hold on;
load([resdir 'results/chairs_arch1_gvae_inst3.mat']);
errorbar(net.nshot,mean(net.nshot_sucrate,2),std(net.nshot_sucrate,[],2),'r');
hold on;
load([resdir 'results/chairs_arch1_mlvae_inst3.mat']);
errorbar(net.nshot,mean(net.nshot_sucrate,2),std(net.nshot_sucrate,[],2),'b');
hold on;
load([resdir 'results/chairs_arch1_vae_inst3.mat']);
errorbar(net.nshot,mean(net.nshot_sucrate,2),std(net.nshot_sucrate,[],2),'g');
hold on;

title('Chairs');
ylim([0 1]); xlim([1 10]);
xlabel('# of shots');
ylabel('success rate');

%%

plot2pdf(gcf,[resdir 'figs/chairs-nshot.pdf'],'size',[10 11]);

%% loading 

nets=load_nets([resdir 'chairs_arch1_gvae_inst3'],'last',true);
net=nets{end};

%%

nets=load_nets([resdir 'chairs_arch1_mlvae_inst3'],'last',true);
net=nets{end};

%%

nets=load_nets([resdir 'chairs_arch1_vae'],'last',true);
net=nets{end};

%%

load([resdir 'results/chairs_arch1_mlvae.mat']);

%%

figure;
x=add_separator(-ds.images(:,:,:,net.oneshot_sucview(round(linspace(1,62,15)))),[-3 -3 -3],'b',1);
montage(reshape(x,ds.wid+2,ds.wid+2,3,[])/6+0.7,'size',[1 15]);

%%

res=vl_simplenn(net.znet_mu,ds.images(:,:,:,ds.test_idx));
tsz=reshape(res(end).x,net.zdim,[]);

%%

res=vl_simplenn(net.znet_pr,ds.images(:,:,:,ds.test_idx));
tsz_pr=reshape(res(end).x,net.zdim,[]);

%%

tsz_mean=mean(tsz,2);
tsz_std=std(tsz,[],2);
[~,idx]=sort(tsz_std,'descend');

figure;
barwitherr(tsz_std(idx),tsz_mean(idx));
xlabel('sorted dimension');
ylabel('z');

%%

load([resdir 'results/chairs_arch1_gvae.mat']);

%%

nshow1=7; nshow2=6;
figure;

x=make_swapping(net,ds,ds.train_rand_idx(1:nshow1),ds.train_rand_idx(end:-1:end-nshow2+1),'neg',true);
img=montage(reshape(x,ds.wid+2,ds.wid+2,3,[])/6+0.7,'size',[nshow2+1 nshow1+1]);
imwrite(img.CData,[resdir 'figs/chairs_arch1_gvae_swapping_train.jpg'],'quality',75);
close(gcf);

%%

nshow1=7; nshow2=6;
figure;

x=make_swapping(net,ds,ds.test_rand_idx(1:nshow1),ds.test_rand_idx(end:-1:end-nshow2+1),'neg',true);
img=montage(reshape(x,ds.wid+2,ds.wid+2,3,[])/6+0.7,'size',[nshow2+1 nshow1+1]);
imwrite(img.CData,[resdir 'figs/chairs_arch1_gvae_swapping_test.jpg'],'quality',75);
close(gcf);

%%

nshow1=7; nshow2=6;
figure;

x=make_comparison_gt(net,ds,ds.train_rand_idx(1:nshow1),ds.train_rand_idx(end:-1:end-nshow1+1),@chairs_find_gt,'neg',true);
img=montage(reshape(x,ds.wid+2,ds.wid+2,3,[])/6+0.7,'size',[2 nshow1]);
imwrite(img.CData,[resdir 'figs/chairs_arch1_gvae_gt_train.jpg'],'quality',75);
close(gcf);

%%

nshow1=7; nshow2=6;
figure;

x=make_comparison_gt(net,ds,ds.test_rand_idx(1:nshow1),ds.test_rand_idx(end:-1:end-nshow1+1),@chairs_find_gt,'neg',true);
img=montage(reshape(x,ds.wid+2,ds.wid+2,3,[])/6+0.7,'size',[2 nshow1]);
imwrite(img.CData,[resdir 'figs/chairs_arch1_gvae_gt_test.jpg'],'quality',75);
close(gcf);

%%

figure;
show1=4; show2=6;
x=make_interpolation(net,ds,ds.train_rand_idx(show1),ds.train_rand_idx(show2),0:1/3:1,-0.25:0.25:1.25,'neg',true);
img=montage(reshape(x,ds.wid+2,ds.wid+2,3,[])/6+0.7,'size',[4 7]);
imwrite(img.CData,[resdir 'figs/chairs_arch1_gvae_interp_train.jpg'],'quality',75);
close(gcf);

%%

figure;
show1=2; show2=11;
x=make_interpolation(net,ds,ds.test_rand_idx(show1),ds.test_rand_idx(show2),0:1/3:1,-0.25:0.25:1.25,'neg',true);
img=montage(reshape(x,ds.wid+2,ds.wid+2,3,[])/6+0.7,'size',[4 7]);
imwrite(img.CData,[resdir 'figs/chairs_arch1_gvae_interp_test.jpg'],'quality',75);
close(gcf);

%%

load([resdir 'results/chairs_arch1_mlvae.mat']);

%%

nshow1=7; nshow2=6;
figure;

x=make_swapping(net,ds,ds.train_rand_idx(1:nshow1),ds.train_rand_idx(end:-1:end-nshow2+1),'neg',true);
img=montage(reshape(x,ds.wid+2,ds.wid+2,3,[])/6+0.7,'size',[nshow2+1 nshow1+1]);
imwrite(img.CData,[resdir 'figs/chairs_arch1_mlvae_swapping_train.jpg'],'quality',75);
close(gcf);

%%

nshow1=7; nshow2=6;
figure;

x=make_swapping(net,ds,ds.test_rand_idx(1:nshow1),ds.test_rand_idx(end:-1:end-nshow2+1),'neg',true);
img=montage(reshape(x,ds.wid+2,ds.wid+2,3,[])/6+0.7,'size',[nshow2+1 nshow1+1]);
imwrite(img.CData,[resdir 'figs/chairs_arch1_mlvae_swapping_test.jpg'],'quality',75);
close(gcf);

%%

figure;
show1=4; show2=6;
x=make_interpolation(net,ds,ds.train_rand_idx(show1),ds.train_rand_idx(show2),0:1/3:1,-0.25:0.25:1.25,'neg',true);
img=montage(reshape(x,ds.wid+2,ds.wid+2,3,[])/6+0.7,'size',[4 7]);
imwrite(img.CData,[resdir 'figs/chairs_arch1_mlvae_interp_train.jpg'],'quality',75);
close(gcf);

%%

figure;
show1=2; show2=11;
x=make_interpolation(net,ds,ds.test_rand_idx(show1),ds.test_rand_idx(show2),0:1/3:1,-0.25:0.25:1.25,'neg',true);
img=montage(reshape(x,ds.wid+2,ds.wid+2,3,[])/6+0.7,'size',[4 7]);
imwrite(img.CData,[resdir 'figs/chairs_arch1_mlvae_interp_test.jpg'],'quality',75);
close(gcf);

%%

load([resdir 'results/chairs_arch1_gvae.mat']);

%%

figure;
errorbar(1:31,mean(net.oneshot_view_sucrate(1,:,:),3),std(net.oneshot_view_sucrate(1,:,:),[],3)); hold on;
errorbar(1.1:31.1,mean(net.oneshot_view_sucrate(2,:,:),3),std(net.oneshot_view_sucrate(2,:,:),[],3));
set(gca,'XTickLabel',[]);
xlim([0.5 31.5]);
% ylim([0.01 0.02]);
% legend('lower','higher','location','southeast');
plot2pdf(gcf,[resdir 'figs/chairs_arch1_gvae_oneshot_view_hist.pdf'],'size',[16 4]);

%%

figure('position',[0 0 600 50]);
c=1:2:31;
c=[1 4 8 12 16 20 24 28 31];
for I=1:length(c)
    subplot(1,length(c),I);
    x=ds.images(:,:,:,c(I));
    x=add_separator(-x,[-2 -2 -2],'b',2);
    imagesc(reshape(x/6+0.7,68,68,3,[]));axis off;axis square;
end
plot2pdf(gcf,[resdir 'figs/chairs_arch1_gvae_oneshot_view_example.pdf'],'size',[25 4]);

