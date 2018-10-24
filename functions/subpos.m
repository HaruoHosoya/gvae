function [sub_x sub_y sub_w sub_h]=subpos(outer,mesh_w,mesh_h,x,y,ratio)
% [sub_x sub_y sub_w sub_h]=subpos(outer,inner,ratio)
%   outer : position [x y w h] of outer frame within the global frame
%   mesh_w,mesh_h : mesh width/height within the outer frame
%   x,y : position of the inner frame in the mesh
%   ratio : ratio of the inner frame within the mesh unit
%  [sub_x sub_y sub_w sub_h] : position of the inner frame within the
%                              global frame
    outer_x=outer(1); outer_y=outer(2); outer_w=outer(3); outer_h=outer(4);
    step_w=outer_w/mesh_w;
    step_h=outer_h/mesh_h;
    sub_x=outer_x+(x-1)*step_w; 
    sub_y=outer_y+(y-1)*step_h;
    sub_w=step_w*ratio;
    sub_h=step_h*ratio;
end

