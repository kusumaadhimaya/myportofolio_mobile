<div align="center">

# Kusuma Putra Abdillah Adhimaya

**NPM:** 2506656936<br>
**Class:** PBP D

</div>

---

## Table of Contents

- [Tugas 7](#tugas-7)
- [AI Disclosure](#ai-disclosure)

---

## Tugas 7

1. Widget tree adalah susunan widget yang membentuk tampilan aplikasi Flutter. Widget dapat memiliki widget lain sebagai child. Widget parent mengatur posisi, ukuran, atau perilaku child-nya. Contohnya, `Scaffold` menjadi parent untuk `AppBar` dan `body`, sedangkan `Column` menyusun beberapa child secara vertikal.

2. Widget yang saya gunakan dalam proyek ini antara lain:
   - `MaterialApp` mengatur aplikasi, termasuk tema dan halaman awal.
   - `Scaffold` menyediakan struktur dasar halaman seperti app bar dan body.
   - `AppBar` menampilkan judul halaman di bagian atas.
   - `Padding` memberi jarak di sekeliling widget.
   - `Column` menyusun widget secara vertikal, sedangkan `Row` menyusunnya secara horizontal.
   - `Center` menempatkan child di tengah ruang yang tersedia.
   - `SizedBox` memberi jarak dengan ukuran tertentu.
   - `GridView.count` menampilkan tombol aksi dalam bentuk kisi.
   - `Card` dan `Container` membungkus konten dengan tampilan dan ukuran tertentu.
   - `Text` menampilkan tulisan dan `Icon` menampilkan ikon.
   - `Material` memberi latar dan bentuk pada kartu aksi. `InkWell` membuat kartu dapat ditekan dan menampilkan efek sentuh.
   - `SnackBar` menampilkan pesan sementara setelah tombol ditekan.
   - `MyApp`, `MyHomePage`, `InfoCard`, dan `ItemCard` adalah widget yang saya buat untuk menyusun aplikasi, halaman utama, kartu informasi profil, dan kartu aksi.

3. `MaterialApp` mengatur bagian dasar aplikasi Flutter, seperti tema, navigasi, dan halaman awal. Widget ini umum digunakan sebagai root karena menyediakan konfigurasi Material Design untuk widget-widget di bawahnya. Dalam proyek ini, `MaterialApp` mengatur tema aplikasi dan menampilkan `MyHomePage` sebagai halaman awal.

4. `StatelessWidget` digunakan ketika tampilan widget tidak menyimpan state yang berubah selama widget berjalan. `StatefulWidget` digunakan ketika tampilan perlu diperbarui karena perubahan state, misalnya nilai penghitung yang berubah setelah tombol ditekan. Halaman utama proyek ini menggunakan `StatelessWidget` karena informasi profil dan daftar tombolnya tidak berubah selama halaman digunakan. Jika nanti halaman perlu mengelola data yang berubah, seperti form atau status login, `StatefulWidget` dapat digunakan.

5. `BuildContext` adalah referensi ke posisi sebuah widget di dalam widget tree. Flutter menggunakannya untuk menemukan informasi dan layanan yang tersedia dari widget-widget di atasnya. Di proyek ini, `Theme.of(context)` mengambil warna dari tema aplikasi, sedangkan `ScaffoldMessenger.of(context)` menemukan messenger untuk menampilkan `SnackBar`.

6. Hot reload menerapkan perubahan kode ke aplikasi yang sedang berjalan tanpa menghapus state saat ini. Hot restart menjalankan ulang aplikasi dari awal dan menghapus state yang tersimpan. Hot reload cocok untuk perubahan UI atau logika kecil. Hot restart diperlukan ketika perubahan tidak dapat diterapkan oleh hot reload, misalnya perubahan pada inisialisasi global atau state awal aplikasi.

**AI Disclosure:** [Lihat bagian AI Disclosure](#ai-disclosure)

---

## AI Disclosure

While working on Tugas 7, I used ChatGPT 6 Luna to support me in understanding the assignment requirements and guide me through implementation when I needed help. I always review its suggestions before trusting them.

### Prompting Strategy

I shared the assignment PDF with the AI to help me understand what I had to do and list the requirements. When I needed help, I asked follow-up questions and the AI guided me through the next steps.
