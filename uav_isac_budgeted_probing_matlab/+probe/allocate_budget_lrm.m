function B = allocate_budget_lrm(alpha, Btot, Bmin, Bmax)
%ALLOCATE_BUDGET_LRM largest-remainder 把连续权重分配成整数预算
% alpha: 1xK 非负权重（不要求和为1）
K = numel(alpha);
alpha = max(alpha, 0);

if sum(alpha) == 0
    alpha = ones(1,K);
end
p = alpha / sum(alpha);

% 先给最小预算
B = Bmin * ones(1,K);
remain = Btot - sum(B);
remain = max(remain, 0);

% 按 p 分配剩余的“理想实数”
ideal = remain * p;
base  = floor(ideal);
frac  = ideal - base;

B = B + base;

% 处理上限
B = min(B, Bmax);

% 由于上限裁剪可能导致预算没用完，再用 LRM 补齐
used = sum(B);
left = Btot - used;

% 按 fractional part 从大到小加1，直到用完
[~, idx] = sort(frac, 'descend');
ii = 1;
while left > 0
    k = idx(ii);
    if B(k) < Bmax
        B(k) = B(k) + 1;
        left = left - 1;
    end
    ii = ii + 1;
    if ii > K, ii = 1; end
    % 防止死循环：如果全到Bmax则退出
    if all(B >= Bmax), break; end
end
end
