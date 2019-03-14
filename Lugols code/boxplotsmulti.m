names=['a_level_lugol','a_mean_img','a_median_img','a_mode_img','a_var_img','b_level_lugol','b_mean_img',...
       'b_median_img','b_mode_img','b_var_img','blue_level_lugol','blue_mean_img','blue_median_img','blue_mode_img',...
       'blue_var_img','CB_level_lugol','CB_mean_img','CB_median_img','CB_mode_img','CB_var_img','CR_level_lugol','CR_mean_img','CR_median_img',...
       'CR_mode_img','CR_var_img','gray_level_lugol','gray_mean_img','gray_median_img','gray_mode_img','gray_var_img',...
       'green_level_lugol','green_mean_img','green_median_img','green_mode_img','green_var_img','h_level_lugol',...
       'h_mean_img','h_median_img','h_mode_img','h_var_img','l_level_lugol','l_mean_img','l_median_img' ,'l_mode_img',...
       'l_var_img','red_level_lugol','red_mean_img','red_median_img','red_mode_img','red_var_img','s_level_lugol',...
       's_mean_img','s_median_img','s_mode_img','s_var_img','v_level_lugol','v_mean_img','v_median_img','v_mode_img',...
       'v_var_img','Y_level_lugol','Y_mean_img','Y_median_img','Y_mode_img','Y_var_img','lesion_size'];

%%
normal=X_norm;
normal=normal(:,7)';
lowgrade=X_CIN1;
lowgrade=lowgrade(:,7)';
highgrade=[X_CIN2;X_CIN3];
highgrade=highgrade(:,7)';
invasive=X_inv;
invasive=invasive(:,7)';
figure;
x1=double(normal)';
x2=double(lowgrade)';
x3=double(highgrade)';
x4=double(invasive)';
group = [repmat({'First'}, 51, 1); repmat({'Second'}, 41, 1); repmat({'Third'}, 15, 1); repmat({'Fourth'}, 8, 1)];
boxplot([x1; x2; x3; x4],group,'labels',{'Normal','Low-grade', 'High-grade','Invasive'})
title(' B mean for cervical cancer grades')
ylabel('B mean')
%%
[h,p]=ttest2(x1,x3)