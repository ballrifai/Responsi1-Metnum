clc; clear; close all;

A = [2.5,  1.5,  5.0, 0.5;   % Adel
     4.0,  0.75, 1.0, 2.0;   % Briza
     2.0,  1.5,  0.5, 6.0;   % Caca
     1.0,  4.25, 2.0, 0.9];  % Dinda

b = [161000;
     149000;
     251500;
     173000];

% 2. Analisis Dominansi Diagonal
n = size(A, 1);
is_sdd = true;
fprintf('=========================================================================\n');
fprintf(' ANALISIS DOMINANSI DIAGONAL MATRIKS AWAL A\n');
fprintf('=========================================================================\n');
for i = 1:n
    diag_val = abs(A(i,i));
    off_diag_sum = sum(abs(A(i,:))) - diag_val;
    fprintf('Baris %d: |a_%d%d| = %.2f, Sum Off-Diag = %.2f\n', i, i, i, diag_val, off_diag_sum);
    if diag_val <= off_diag_sum
        is_sdd = false;
    end
end

if is_sdd
    fprintf('KESIMPULAN: Matriks A awal DOMINAN DIAGONAL KETAT (SDD).\n');
else
    fprintf('KESIMPULAN: Matriks A awal TIDAK dominan diagonal ketat.\n');
end
fprintf('=========================================================================\n\n');

% 3. METODE LANGSUNG (METODE ELIMINASI GAUSS-JORDAN)
fprintf('=========================================================================\n');
fprintf(' EKSEKUSI METODE LANGSUNG (GAUSS-JORDAN)\n');
fprintf('=========================================================================\n');

% Membentuk Matriks Augmented [A|b]
Aug = [A b];
fprintf('Matriks Augmented Awal:\n');
disp(Aug);

% Proses Eliminasi Gauss-Jordan
for i = 1:n
    % Pivotisasi Utama (Penerapan Partial Pivoting untuk Stabilitas Numerik)
    [~, max_idx] = max(abs(Aug(i:n, i)));
    max_idx = max_idx + i - 1;
    if max_idx ~= i
        Aug([i, max_idx], :) = Aug([max_idx, i], :);
    end

    % Normalisasi Elemen Pivot Menjadi 1
    Aug(i, :) = Aug(i, :) / Aug(i, i);

    % Eliminasi Kolom i pada Baris Lainnya
    for j = 1:n
        if j ~= i
            factor = Aug(j, i);
            Aug(j, :) = Aug(j, :) - factor * Aug(i, :);
        end
    end
end

x_direct = Aug(:, end);

fprintf('Hasil Perhitungan Metode Gauss-Jordan (Harga per kg):\n');
fprintf(' - Harga Beras  (x1) : Rp %12.2f / kg\n', x_direct(1));
fprintf(' - Harga Telur  (x2) : Rp %12.2f / kg\n', x_direct(2));
fprintf(' - Harga Tepung (x3) : Rp %12.2f / kg\n', x_direct(3));
fprintf(' - Harga Ayam   (x4) : Rp %12.2f / kg\n', x_direct(4));
fprintf('=========================================================================\n\n');

A_sdd = [4.0,  0.75, 1.0, 2.0;   % Briza
         1.0,  4.25, 2.0, 0.9;   % Dinda
         2.5,  1.5,  5.0, 0.5;   % Adel
         2.0,  1.5,  0.5, 6.0];  % Caca

b_sdd = [149000;
         173000;
         161000;
         251500];

fprintf('=========================================================================\n');
fprintf(' EKSEKUSI METODE TIDAK LANGSUNG (GAUSS-SEIDEL SETELAH RE-ORDERING BARIS)\n');
fprintf('=========================================================================\n');

x_gs = zeros(n, 1); % Inisialisasi Tebakan Awal [0; 0; 0; 0]
tol = 1e-5;
max_iter = 100;
fprintf('Iterasi |     x1 (Beras)     |     x2 (Telur)     |    x3 (Tepung)     |     x4 (Ayam)      | Max Galat Relatif\n');
fprintf('--------------------------------------------------------------------------------------------------------------\n');

for iter = 1:max_iter
    x_old = x_gs;

    x_gs(1) = (b_sdd(1) - A_sdd(1,2)*x_gs(2) - A_sdd(1,3)*x_gs(3) - A_sdd(1,4)*x_gs(4)) / A_sdd(1,1);
    x_gs(2) = (b_sdd(2) - A_sdd(2,1)*x_gs(1) - A_sdd(2,3)*x_gs(3) - A_sdd(2,4)*x_gs(4)) / A_sdd(2,2);
    x_gs(3) = (b_sdd(3) - A_sdd(3,1)*x_gs(1) - A_sdd(3,2)*x_gs(2) - A_sdd(3,4)*x_gs(4)) / A_sdd(3,3);
    x_gs(4) = (b_sdd(4) - A_sdd(4,1)*x_gs(1) - A_sdd(4,2)*x_gs(2) - A_sdd(4,3)*x_gs(3)) / A_sdd(4,4);

    % Perhitungan Error Relatif
    ea = max(abs((x_gs - x_old) ./ x_gs));

    fprintf('  %3d   | Rp %12.2f | Rp %12.2f | Rp %12.2f | Rp %12.2f | %15.6e\n', ...
        iter, x_gs(1), x_gs(2), x_gs(3), x_gs(4), ea);

    if ea < tol
        break;
    end
end
fprintf('=========================================================================\n');
