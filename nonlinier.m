clc; clear; close all;

f = @(r) (4/3) * pi * (r.^3) - 300;

% Penentuan Interval Awal Menggunakan Metode Grafik
r_vals = linspace(0, 7, 500);
f_vals = f(r_vals);

figure('Color', 'w', 'Position', [150, 150, 800, 450]);
plot(r_vals, f_vals, 'b-', 'LineWidth', 2, 'DisplayName', 'f(r) = (4/3)\pi r^3 - 300');
hold on;
yline(0, 'k--', 'LineWidth', 1.2, 'DisplayName', 'Sumbu f(r) = 0');
xline(4, 'm--', 'LineWidth', 1.2, 'DisplayName', 'Batas Bawah a = 4');
xline(5, 'c--', 'LineWidth', 1.2, 'DisplayName', 'Batas Atas b = 5');

% Menandai Titik Akar Grafik
r_root_exact = (300 * 3 / (4*pi))^(1/3);
plot(r_root_exact, 0, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r', 'DisplayName', sprintf('Akar r \\approx %.4f', r_root_exact));
hold off;

grid on;
title('Analisis Grafik Lokasi Akar Persamaan Non-Linier f(r) = 0', 'FontSize', 12);
xlabel('Jari-Jari r (cm)', 'FontSize', 11);
ylabel('Nilai Fungsi f(r)', 'FontSize', 11);
legend('Location', 'northwest');
axis([0 7 -400 1000]);

% 3. EKSEKUSI METODE BISEKSI (AKAR PERSAMAAN)
a = 4;
b = 5;
tol = 1e-6;
max_iter = 50;

fprintf('=========================================================================\n');
fprintf(' HASIL ITERASI METODE BISEKSI (BATAS AWAL [%d, %d])\n', a, b);
fprintf('=========================================================================\n');
fprintf('Iter |      a      |      b      |      c      |    f(c)     |   Galat Relatif\n');
fprintf('-------------------------------------------------------------------------\n');

c_old = a;
for iter = 1:max_iter
    c = (a + b) / 2;
    fc = f(c);

    if iter == 1
        ea = 100;
    else
        ea = abs((c - c_old) / c) * 100;
    end

    fprintf('%4d | %11.6f | %11.6f | %11.6f | %11.6f | %13.6e%%\n', ...
        iter, a, b, c, fc, ea);

    if abs(fc) < tol || ea < tol
        break;
    end

    if f(a) * fc < 0
        b = c;
    else
        a = c;
    end
    c_old = c;
end

r_sol = c;
fprintf('=========================================================================\n');
fprintf('Akar Jari-Jari Terhitung (r) = %.6f cm\n', r_sol);
fprintf('=========================================================================\n\n');

% 4. PERHITUNGAN VOLUME TABUNG DAN VOLUME DILUAR BOLA
V_bola = (4/3) * pi * (r_sol^3);
V_tabung = pi * (r_sol^2) * (2 * r_sol);
V_diluar = V_tabung - V_bola;

fprintf('=========================================================================\n');
fprintf(' HASIL PERHITUNGAN GEOMETRI DAN VOLUME AKHIR\n');
fprintf('=========================================================================\n');
fprintf(' - Jari-Jari Bangun Ruang (r)   : %12.6f cm\n', r_sol);
fprintf(' - Tinggi Tabung (t = 2r)       : %12.6f cm\n', 2*r_sol);
fprintf(' - Volume Bola (V_bola)         : %12.6f cm3\n', V_bola);
fprintf(' - Volume Tabung Total (V_tabung): %12.6f cm3\n', V_tabung);
fprintf(' - Volume Tabung di Luar Bola   : %12.6f cm3\n', V_diluar);
fprintf('=========================================================================\n');
