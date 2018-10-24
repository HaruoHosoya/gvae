addpath(pwd);
addpath([pwd filesep 'functions']);
addpath([pwd filesep 'preprocess']);
addpath([pwd filesep 'cnn']);
addpath([pwd filesep 'app_chairs']);
addpath([pwd filesep 'app_chars']);
addpath([pwd filesep 'app_hands']);
addpath([pwd filesep 'app_kth_move']);
addpath([pwd filesep 'app_kth_stand']);
addpath([pwd filesep 'app_mnist']);
addpath([pwd filesep 'app_multipie']);
addpath([pwd filesep 'app_multipie2']);
addpath([pwd filesep 'app_ytface']);
addpath('../fmin_adam');
wd=pwd; 
if gpuDeviceCount>0
    cd('../matconvnet-1.0-beta25-gpu');
else    
    cd('../matconvnet-1.0-beta25');
end
run matlab/vl_setupnn
% mexAll;
cd(wd);


