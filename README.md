This is part of the code used to implement and evaluate the group-based variational autoencoder (GVAE) by Haruo Hosoya [1].

The code relies on
  * matconvnet-1.0-beta25 (downloadable from [2])
  * Matlab implementation of ADAM optimizer (modified from Dylan Muir's implementation [3]; included in the code here)

To understand how the code works, it is recommended to start by looking at the app_chairs folder, especially:
  * chairs_setup_ds.m
  * chairs_train_models.m
  * chairs_test_models.m

Then, the most important functions used in these and related to GVAE are:
  * create_net.m
  * learn_net.m
  * obj_gvae.m

Others are mostly auxiliary or for visualization/evaluation purposes.

If you publish a paper based on this code, please cite [1] or any following conference/journal publication.

[1] Haruo Hosoya.  
A simple probabilistic deep generative model for learning generalizable disentangled representations from grouped data.  arXiv:1809.02383, 2018.

[2] http://www.vlfeat.org/matconvnet/

[3] https://jp.mathworks.com/matlabcentral/fileexchange/61616-adam-stochastic-gradient-descent-optimization
