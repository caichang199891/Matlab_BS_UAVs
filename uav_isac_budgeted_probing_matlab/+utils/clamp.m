function y = clamp(x, lo, hi)
%CLAMP Clamp values to [lo, hi]
y = min(max(x, lo), hi);
end
