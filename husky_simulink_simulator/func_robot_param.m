body.mass=2.2337;
body.MomentsofInertia=[0.0030709, 0.0046624, 0.0035462];
body.ProductsofInertia=[0.00010331, 0.00058252, -0.00020765];

femur_left.mass=0.71952;
femur_left.MomentsofInertia=[0.00047141, 0.00072824, 0.00044539];
femur_left.ProductsofInertia=[-1.4185e-06, -3.9569e-05, -6.3308e-06];

femur_right.mass=0.71952;
femur_right.MomentsofInertia=[0.00047141, 0.00072824, 0.00044539];
femur_right.ProductsofInertia=[1.4185e-06, 3.9569e-05, -6.3308e-06];

% Original values 
% 
% hip_left.mass=0.02228;
% hip_left.MomentsofInertia=[0.00000585,  0.00001678, 0.00001514];
% hip_left.ProductsofInertia=[0, -5e-08, 1.48e-06];
% 
% hip_right.mass=0.02228;
% hip_right.MomentsofInertia=[0.00000585,  0.00001678, 0.00001514];
% hip_right.ProductsofInertia=[0, 5e-08, -1.48e-06];

% tibia_left.mass=0.323034205629986;
% tibia_left.MomentsofInertia=[0.0005802981403470251, 0.000703725589207329, 0.000533163251971044];
% tibia_left.ProductsofInertia=[-5.14070037039191e-07, -4.54880548592882e-05, 1.21346102972198e-06];
% 
% tibia_right.mass=0.323034205629986;
% tibia_right.MomentsofInertia=[0.0005802981403470251, 0.000703725589207329, 0.000533163251971044];
% tibia_right.ProductsofInertia=[-5.14070037039209e-07, 4.54880548592882e-05, -1.21346102972198e-06];
% 
% tarsus_left.mass=0.18284;
% tarsus_left.MomentsofInertia=[0.00012076, 0.00011699, 2.5133e-05];
% tarsus_left.ProductsofInertia=[3.7744e-12, -6.9478e-13, -8.513900000000001e-12];
% 
% tarsus_right.mass=0.18284;
% tarsus_right.MomentsofInertia=[0.00012076, 0.00011699, 2.5133e-05];
% tarsus_right.ProductsofInertia=[-3.7744e-12, 6.9478e-13, -8.513900000000001e-12];
hip_left.pCOM=
hip_left.mass=0.001;
hip_left.MomentsofInertia=[0, 0, 0];
hip_left.ProductsofInertia=[0, 0, 0];

hip_right.mass=0.001;
hip_right.MomentsofInertia=[0, 0, 0];
hip_right.ProductsofInertia=[0, 0, 0];

tibia_left.mass=0.001;
tibia_left.MomentsofInertia=[0, 0, 0];
tibia_left.ProductsofInertia=[0, 0, 0];

tibia_right.mass=0.001;
tibia_right.MomentsofInertia=[0, 0, 0];
tibia_right.ProductsofInertia=[0, 0, 0];

tarsus_left.mass=0.001;
tarsus_left.MomentsofInertia=[0, 0, 0];
tarsus_left.ProductsofInertia=[0, 0, 0];

tarsus_right.mass=0.001;
tarsus_right.MomentsofInertia=[0, 0, 0];
tarsus_right.ProductsofInertia=[0, 0, 0];

link_right.mass=0.0;
link_right.MomentsofInertia=[0,0,0];
link_right.ProductsofInertia=[0,0,0];

link_left.mass=0.0;
link_left.MomentsofInertia=[0 0 0];
link_left.ProductsofInertia=[0 0 0];

% link_right.mass=0.022232;
% link_right.MomentsofInertia=[9.8756e-07, 2.5372e-05, 2.4918e-05];
% link_right.ProductsofInertia=[-2.764e-14, 1.2525e-13, -3.8111e-08];
% 
% link_left.mass=0.022232;
% link_left.MomentsofInertia=[9.8756e-07, 2.5372e-05, 2.4918e-05];
% link_left.ProductsofInertia=[-2.764e-14, -1.2498e-13, 3.8111e-08];

backbone_mass_pos_wrt_body = [0.021107, -5.5457e-05, -0.041523];


hip_FR_origin_wrt_backbone = [0.19745, -0.045, 0];
hip_FL_origin_wrt_backbone = [0.19745, 0.045, 0];
hip_BR_origin_wrt_backbone = [-0.19745, -0.045, 0];
hip_BL_origin_wrt_backbone = [-0.19745, 0.045, 0];

hip_orgin_wrt_backbone = [hip_FR_origin_wrt_backbone, hip_FL_origin_wrt_backbone, hip_BR_origin_wrt_backbone, hip_BL_origin_wrt_backbone].';


hip_mass_loc = [0.024751, 0.0025459, 6.0284e-05];

femur_right_origin_wrt_hip = [0.053, 0.007, 0];

femur_mass_loc = [2.704e-07, -0.036112, -0.082829];