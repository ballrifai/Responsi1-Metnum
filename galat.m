clc; clear; close all;


lambda = 12;
v = 36;
x = 10;
h0 = 5;
t = linspace(0, 5, 500);

u = (t .* v) / lambda;
cos_eksak = cos(u);
exp_eksak = exp(x);
h_eksak = h0 * (cos_eksak + exp_eksak);

n_vec = [23, 24, 25];
h_approx = zeros(length(n_vec), length(t));
galat_mutlak = zeros(length(n_vec), length(t));
galat_relatif_persen = zeros(length(n_vec), length(t));
rerata_galat_mutlak = zeros(length(n_vec), 1);
rerata_galat_relatif = zeros(length(n_vec), 1);

for idx = 1:length(n_vec)
    n = n_vec(idx);

    exp_app = 0;
    for k = 0:(n-1)
        exp_app = exp_app + (x^k) / factorial(k);
    end

    cos_app = zeros(size(u));
    for k = 0:(n-1)
        cos_app = cos_app + ((-1)^k .* (u.^(2*k))) / factorial(2*k);
    end

    % Formula Gelombang Hasil Pendekatan
    h_approx(idx, :) = h0 * (cos_app + exp_app);

    % Perhitungan Galat Mutlak & Galat Relatif (%)
    galat_mutlak(idx, :) = abs(h_eksak - h_approx(idx, :));
    galat_relatif_persen(idx, :) = (galat_mutlak(idx, :) ./ abs(h_eksak)) * 100;

    % Rerata Galat
    rerata_galat_mutlak(idx) = mean(galat_mutlak(idx, :));
    rerata_galat_relatif(idx) = mean(galat_relatif_persen(idx, :));
end

figure('Color', 'w', 'Position', [100, 100, 900, 500]);
plot(t, h_eksak, 'k-', 'LineWidth', 2.5, 'DisplayName', 'f_{eksak} (Perhitungan Eksak)');
hold on;
plot(t, h_approx(1, :), 'r--', 'LineWidth', 1.5, 'DisplayName', sprintf('f_{n=23} (Approksimasi n=23)'));
plot(t, h_approx(2, :), 'g-.', 'LineWidth', 1.5, 'DisplayName', sprintf('f_{n=24} (Approksimasi n=24)'));
plot(t, h_approx(3, :), 'b:', 'LineWidth', 1.8, 'DisplayName', sprintf('f_{n=25} (Approksimasi n=25)'));
hold off;

grid on;
title('Perbandingan Gelombang Air Laut: Eksak vs Pendekatan Deret', 'FontSize', 12);
xlabel('Waktu (t) [detik]', 'FontSize', 11);
ylabel('Ketinggian Gelombang (h)', 'FontSize', 11);
legend('Location', 'northeastoutside');
axis tight;

% 5. Tampilan Hasil Analisis Error pada Command Window
fprintf('=========================================================================\n');
fprintf(' HASIL EVALUASI GALAT KASUS 1 (TOLERANSI ERROR = 1%%)\n');
fprintf('=========================================================================\n');
fprintf(' Suku (n) | Rerata Galat Mutlak | Rerata Galat Relatif (%%) | Status Toleransi\n');
fprintf('-------------------------------------------------------------------------\n');
for idx = 1:length(n_vec)
    status = 'LAYAK (<= 1%)';
    if rerata_galat_relatif(idx) > 1
        status = 'TIDAK LAYAK (> 1%)';
    end
    fprintf('   n = %d  | %18.6f | %22.6f%% | %s\n', ...
        n_vec(idx), rerata_galat_mutlak(idx), rerata_galat_relatif(idx), status);
end
fprintf('=========================================================================\n');
