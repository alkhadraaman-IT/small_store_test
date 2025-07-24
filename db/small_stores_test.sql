-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 24, 2025 at 02:28 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `small_stores_test`
--

-- --------------------------------------------------------

--
-- Table structure for table `announcements`
--

CREATE TABLE `announcements` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `store_id` bigint(20) UNSIGNED NOT NULL,
  `announcement_description` varchar(255) NOT NULL,
  `announcement_date` date NOT NULL,
  `announcement_state` tinyint(1) NOT NULL DEFAULT 1,
  `announcement_photo` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `announcements`
--

INSERT INTO `announcements` (`id`, `store_id`, `announcement_description`, `announcement_date`, `announcement_state`, `announcement_photo`, `created_at`, `updated_at`) VALUES
(1, 1, 'خفضنا الاسعاار', '2025-08-02', 1, 'default.png', '2025-07-20 18:28:28', '2025-07-20 18:28:28');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `favorites`
--

CREATE TABLE `favorites` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `state` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `favorites`
--

INSERT INTO `favorites` (`id`, `user_id`, `product_id`, `state`, `created_at`, `updated_at`) VALUES
(1, 2, 2, 1, '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(2, 2, 1, 1, '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(3, 3, 2, 1, '2025-07-20 18:28:28', '2025-07-20 18:28:28');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_07_20_150758_create_store_classes_table', 1),
(5, '2025_07_20_150763_create_types_table', 1),
(6, '2025_07_20_150810_create_stores_table', 1),
(7, '2025_07_20_150918_create_products_table', 1),
(8, '2025_07_20_151000_create_announcements_table', 1),
(9, '2025_07_20_151052_create_favorites_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `store_id` bigint(20) UNSIGNED NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `type_id` bigint(20) UNSIGNED NOT NULL,
  `product_description` varchar(255) NOT NULL,
  `product_price` int(11) NOT NULL,
  `product_available` tinyint(1) NOT NULL DEFAULT 1,
  `product_state` tinyint(1) NOT NULL DEFAULT 1,
  `product_photo_1` varchar(255) NOT NULL,
  `product_photo_2` varchar(255) DEFAULT NULL,
  `product_photo_3` varchar(255) DEFAULT NULL,
  `product_photo_4` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `store_id`, `product_name`, `type_id`, `product_description`, `product_price`, `product_available`, `product_state`, `product_photo_1`, `product_photo_2`, `product_photo_3`, `product_photo_4`, `created_at`, `updated_at`) VALUES
(1, 2, 'كنزة قطن', 10, 'قطن 100% ألوان :أحمر وأسود فقط القياس 7و8', 50000, 1, 1, 'default.png', NULL, NULL, NULL, '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(2, 2, ' كنزة قطن نص كم', 11, 'قطن 100% ألوان :أحمر وأسود فقط القياس 40و50', 55000, 1, 1, 'default.png', NULL, NULL, NULL, '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(3, 2, 'كنزة قطن كم طويل', 12, 'قطن 100% ألوان :أحمر وأسود فقط القياس40و42', 65000, 1, 1, 'default.png', NULL, NULL, NULL, '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(4, 1, 'شعار مقهى', 6, 'يعبر عن المشروبات الساحنة مع تناسق الالوان', 20000, 1, 1, 'default.png', NULL, NULL, NULL, '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(5, 1, 'شعار مكتبة', 6, 'يعبر عن العلم ولونه يحفز التعلم ', 20000, 1, 1, 'default.png', NULL, NULL, NULL, '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(6, 3, ' كنزة نص كم', 11, 'قطن 100% ألوان :أحمر وأسود فقط القياس 40و50', 55000, 1, 1, 'default.png', NULL, NULL, NULL, '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(7, 3, 'كنزة كم طويل', 13, 'قطن 100% ألوان :أحمر وأسود فقط القياس2 و4 ', 65000, 1, 1, 'default.png', NULL, NULL, NULL, '2025-07-20 18:28:28', '2025-07-20 18:28:28');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `stores`
--

CREATE TABLE `stores` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `store_name` varchar(255) NOT NULL,
  `store_phone` int(11) NOT NULL,
  `store_place` varchar(255) NOT NULL,
  `class_id` bigint(20) UNSIGNED NOT NULL,
  `store_description` varchar(255) NOT NULL,
  `store_state` tinyint(1) NOT NULL DEFAULT 1,
  `store_photo` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `stores`
--

INSERT INTO `stores` (`id`, `user_id`, `store_name`, `store_phone`, `store_place`, `class_id`, `store_description`, `store_state`, `store_photo`, `created_at`, `updated_at`) VALUES
(1, 2, 'برامجك', 987654321, 'دمشق بجوار جامع أبو النور', 2, 'نبيع أفضل المنتجات بأسعار منافسة', 1, 'default.png', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(2, 1, 'ملبوساتك', 987654322, 'دمشق بجوار جامع الرحمن', 3, 'نبيع أفضل المنتجات بأسعار منافسة', 1, 'default.png', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(3, 2, 'من عنا', 987654333, 'دمشق بجوار جامع التقوى', 3, 'نبيع أفضل المنتجات بأسعار منافسة', 1, 'default.png', '2025-07-20 18:28:28', '2025-07-20 18:28:28');

-- --------------------------------------------------------

--
-- Table structure for table `store_classes`
--

CREATE TABLE `store_classes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `class_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `store_classes`
--

INSERT INTO `store_classes` (`id`, `class_name`, `created_at`, `updated_at`) VALUES
(1, 'زينة حفلات', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(2, 'برمجة', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(3, 'ملبوسات', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(4, 'مواد طبيعية', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(5, 'اعمال يدوية', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(6, 'غذائيات', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(7, 'غير ذلك', '2025-07-20 18:28:28', '2025-07-20 18:28:28');

-- --------------------------------------------------------

--
-- Table structure for table `types`
--

CREATE TABLE `types` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `class_id` bigint(20) UNSIGNED NOT NULL,
  `type_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `types`
--

INSERT INTO `types` (`id`, `class_id`, `type_name`, `created_at`, `updated_at`) VALUES
(1, 1, 'تخرج', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(2, 1, 'ذكرى ولادة', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(3, 1, 'قدوم مولود', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(4, 1, 'أعياد', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(5, 1, 'غير ذلك', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(6, 2, 'تصميم', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(7, 2, 'برمجة مواقع', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(8, 2, 'برمجة تطبيقات', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(9, 2, 'غير ذلك', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(10, 3, 'ملابس أطفال', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(11, 3, 'ملابس رجال', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(12, 3, 'ملابس نشاء', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(13, 3, 'ملابس رضع ', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(14, 3, 'غير ذلك', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(15, 4, ' صابون', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(16, 4, 'عطور', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(17, 4, ' عناية بالبشرة', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(18, 5, 'صوف', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(19, 5, 'غير ذلك', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(20, 6, 'عصائر', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(21, 6, ' أطعمة مالحة', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(22, 6, 'حلويات', '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(23, 6, 'غير ذلك', '2025-07-20 18:28:28', '2025-07-20 18:28:28');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `phone` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `profile_photo` varchar(255) DEFAULT NULL,
  `type` tinyint(1) NOT NULL DEFAULT 1,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `phone`, `email`, `email_verified_at`, `password`, `profile_photo`, `type`, `status`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'admin', 987654321, 'admin@test.com', NULL, '$2y$12$xjuKiY/KNuJA6dmUwoGAzes4PKtjCP2bHF7tM75AGGPjM3LJ3JM5C', 'default.png', 0, 1, NULL, '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(2, 'user1', 987654322, 'user1@test.com', NULL, '$2y$12$p1sF/mk4Vj/dBPcJT.JKZuXr3CxALooo.RVEQWVGH.yqYfk0HiYSG', 'default.png', 1, 1, NULL, '2025-07-20 18:28:28', '2025-07-20 18:28:28'),
(3, 'user2', 987654333, 'user2@test.com', NULL, '$2y$12$xrHtyLJwt5Mf32tTEKQSbeFAJVJr32B6mnoWPjA985OsoCbpzm3e.', 'default.png', 1, 1, NULL, '2025-07-20 18:28:28', '2025-07-20 18:28:28');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `announcements`
--
ALTER TABLE `announcements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `announcements_store_id_foreign` (`store_id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `favorites_user_id_foreign` (`user_id`),
  ADD KEY `favorites_product_id_foreign` (`product_id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `products_store_id_foreign` (`store_id`),
  ADD KEY `products_type_id_foreign` (`type_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `stores`
--
ALTER TABLE `stores`
  ADD PRIMARY KEY (`id`),
  ADD KEY `stores_user_id_foreign` (`user_id`),
  ADD KEY `stores_class_id_foreign` (`class_id`);

--
-- Indexes for table `store_classes`
--
ALTER TABLE `store_classes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `types`
--
ALTER TABLE `types`
  ADD PRIMARY KEY (`id`),
  ADD KEY `types_class_id_foreign` (`class_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_phone_unique` (`phone`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `announcements`
--
ALTER TABLE `announcements`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `favorites`
--
ALTER TABLE `favorites`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `stores`
--
ALTER TABLE `stores`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `store_classes`
--
ALTER TABLE `store_classes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `types`
--
ALTER TABLE `types`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `announcements`
--
ALTER TABLE `announcements`
  ADD CONSTRAINT `announcements_store_id_foreign` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`);

--
-- Constraints for table `favorites`
--
ALTER TABLE `favorites`
  ADD CONSTRAINT `favorites_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `favorites_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_store_id_foreign` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`),
  ADD CONSTRAINT `products_type_id_foreign` FOREIGN KEY (`type_id`) REFERENCES `types` (`id`);

--
-- Constraints for table `stores`
--
ALTER TABLE `stores`
  ADD CONSTRAINT `stores_class_id_foreign` FOREIGN KEY (`class_id`) REFERENCES `store_classes` (`id`),
  ADD CONSTRAINT `stores_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `types`
--
ALTER TABLE `types`
  ADD CONSTRAINT `types_class_id_foreign` FOREIGN KEY (`class_id`) REFERENCES `store_classes` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
