%%
%% chairs data
%%

rng_orig=rng(1);

%% got through https://github.com/jimeiyang/deepRotator

chairs=load('~/datasets/chairs_data/chairs_data_64x64x3_crop.mat');

%%

ds=struct;
ds.wid=64;
ds.dep=3;

%%

ds.images=chairs.images;
ds.ids=chairs.ids;
ds.theta=chairs.theta';
ds.phi=chairs.phi';

%%

imgs=double(ds.images(:,:,:,randi(1000,1)));
img_mean=mean(imgs(:));
img_std=std(imgs(:));
ds.images=(double(ds.images)-img_mean)/img_std;

%%

ds.all_ids=unique(ds.ids);
ds.all_theta=unique(ds.theta);
ds.all_phi=unique(ds.phi);

ds.train_idx=find(ds.ids<=650);
ds.test_idx=find(ds.ids>650);

ds.train_ids=ds.all_ids(ds.all_ids<=650);
ds.test_ids=ds.all_ids(ds.all_ids>650);

%%

ds.train_rand_idx=ds.train_idx(randperm(length(ds.train_idx)));
ds.test_rand_idx=ds.test_idx(randperm(length(ds.test_idx)));

%%

% datadir='~/resultsets/gentrans3/20180713/chairs/data/';
datadir='~/resultsets/gentrans3/20180725/chairs/data/';

%%

mkdir(datadir);

%%

save([datadir 'ds.mat'],'ds','-v7.3');

%%

rng(rng_orig);


