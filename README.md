## Pengalaman Mengerjakan Project & Pelajaran

Proses pengerjaan aplikasi saham ini lumayan seru dan menantang buatku. Karena tahun lalu aku sebenarnya sudah pernah daftar SIG Mobile Development, project ini sekalian jadi momen buat me-recall banyak materi Flutter yang sudah kupelajari. Waktu liburan kemarin aku juga sempat eksplorasi lebih jauh, jadi rasanya pas banget bisa langsung praktik bikin aplikasi dengan data yang dinamis. Dari proses ini, aku makin sadar kalau aku memang lebih nyaman dan enjoy mengerjakan bagian frontend. Mengatur UI yang clean, merapikan komponen agar menyatu, dan memperbagus tampilan aplikasi rasanya jauh lebih asik dan aku merasa sudah cukup paham di area tersebut.

Tapi tantangan terbesarnya mulai muncul saat masuk ke bagian integrasi API. Walaupun dasar-dasar API sebenarnya sudah lumayan kupelajari di mata kuliah PBP, kali ini aku menantang diri sendiri untuk menggunakan package Dio dan Riverpod supaya struktur kodenya lebih rapi. Ternyata proses belajarnya lumayan bikin pusing, apalagi pas harus parsing data dari Alpha Vantage dan berhadapan dengan limit request mereka. Bagian logic dan state management ini benar-benar menyita waktu lebih lama dari perkiraanku.

Selain soal kode, aku juga dapat pelajaran berharga soal manajemen project. Awalnya aku sudah membuat repository dan mencoba menerapkan alur commit serta branching yang rapi. Tapi di tengah jalan, aku merasa perlu merombak struktur foldernya. Karena perubahannya cukup drastis dan malah bikin pusing sendiri mengatur rekam jejak Git-nya, pada akhirnya aku memutuskan untuk membuat repository baru saja agar lebih bersih dan terstruktur dari awal.

Untuk menyelesaikan semua kendala tersebut, aku menggunakan beberapa referensi. Aku banyak membaca dokumentasi resmi dari Flutter dan Alpha Vantage. Selain itu, aku juga menonton ulang referensi dari sebuah playlist YouTube di link https://www.youtube.com/watch?v=DR4Vuu_VSZA&list=PL5jb9EteFAOAusKTSuJ5eRl1BapQmMDT6 karena sebelumnya aku pernah mencoba mengikuti tutorial dari sana dan penjelasannya cukup enak. Kalau ada error yang benar-benar mentok, aku biasanya bertanya ke AI untuk mencari solusi alternatif. Proses pembuatan aplikasi ini benar-benar menyadarkan aku bahwa masih butuh banyak latihan, terutama untuk membiasakan diri dengan integrasi data yang kompleks.

---

## Fitur-Fitur yang Ada

* **Market Data:** Pengguna bisa melihat daftar saham yang lagi naik (*gainers*), turun (*losers*), atau paling aktif.
* **Stock Detail & Chart:** Halaman detail yang menampilkan harga saham terkini, grafik pergerakan dengan filter waktu, statistik utama perusahaan (Market Cap, P/E Ratio, Sector, Div Yield), serta deskripsi perusahaan beserta tombol untuk membuka website resminya.
* **Market News:** Halaman buat baca berita-berita terbaru seputar finansial dan pasar saham.
* **User Profile:** Halaman khusus buat liat dan edit informasi user dengan tampilan form yang *clean*.

---

## Third Party Libraries yang Dipakai

Berikut beberapa package yang aku pake di project ini, beserta fungsinya:

* **`flutter_riverpod`**
  Package ini dipakai buat state management. Bikin proses ngambil data dari API, caching, dan update UI jadi lebih gampang dan rapi.
* **`dio`**
  Library ini buat ngelakuin HTTP request ke API Alpha Vantage. Lebih enak dipake dibanding http bawaan buat narik data saham sama berita karena fiturnya lebih lengkap.
* **`hive` & `hive_flutter`**
  Ini database lokal buat nyimpen data di device. Aku pake ini buat nyimpen data profil user atau settingan lokal lainnya. Kenceng banget dibanding shared_preferences.
* **`fl_chart`**
  Library andalan buat bikin grafik. Di project ini aku pake buat nampilin chart pergerakan harga saham biar tampilannya kayak aplikasi trading beneran.
* **`flutter_dotenv`**
  Package ini buat nyimpen API Key di dalem file `.env` biar lebih aman dan ga langsung keliatan di dalem kode.
* **`url_launcher`**
  Berguna buat buka link eksternal. Di app ini, aku gunain buat tombol visit website di halaman detail perusahaan biar langsung buka browser bawaan HP.
* **`intl`**
  Ini library buat formatting angka. Aku gunain buat ngerapihin format harga saham atau angka volume biar gampang dibaca.
* **`iconsax`**
  Package yang nyediain kumpulan icon custom yang elegan. Bikin tampilan UI aplikasi jadi keliatan jauh lebih modern.
* **`image_picker`**
  Package ini berguna buat ngambil gambar dari gallery atau kamera. Di app ini dipakai untuk ambil gambar profil user.