function fc = window_fc(window_length, window_step, func_roi)
    for w=1:(size(func_roi,1)-window_length)/window_step-1
        func_roi(:, window_length)
    end
end


