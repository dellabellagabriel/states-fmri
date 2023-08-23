function windows = bold_to_windows(func_roi)
%this function takes a bold signal matrix (regions x time) and returns
%the windowed signal

n_rois = size(func_roi, 1);
n_times = size(func_roi, 2);

tapered_window = hamming(22);
slide_step = 1;
n_windows = (n_times-length(tapered_window))/slide_step+1;

windows = zeros(n_windows, n_rois*(n_rois-1)/2);
for w=1:n_windows
  time_from = (w-1)*slide_step+1;
  time_to = length(tapered_window)+(w-1)*slide_step;

  window_data = func_roi(:, time_from:time_to) .* repmat(tapered_window, 1, n_rois)';
  windows(w, :, :) = tri2vec(corrcoef(window_data'));
end

end

