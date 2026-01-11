function y = softmax(x)
%SOFTMAX Compute softmax
x = x - max(x(:));
ex = exp(x);
y = ex ./ sum(ex(:));
end
