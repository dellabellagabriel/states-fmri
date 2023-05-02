function func_roi = bold_to_networks(data, roi_mask)
%this function takes a [x,y,z,t] matrix from a a bold time series and a roi mask and returns
%returns the 264 ROI consensus
   num_roi = 264;
   numbers_roi = 1:264;
   x_size = size(data, 1);
   y_size = size(data, 2);
   z_size = size(data, 3);
   t_size = size(data, 4);
   
   func_roi = zeros(num_roi, t_size);
   for r=1:num_roi
       for t=1:t_size
            mask = reshape(roi_mask == numbers_roi(r), x_size*y_size*z_size, 1);
            data_reshape = reshape(data(:,:,:,t), x_size*y_size*z_size, 1);
            func_roi(r,t) = mean(data_reshape(mask));
       end
   end
end

