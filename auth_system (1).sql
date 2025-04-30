-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 30, 2025 at 12:58 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `auth_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `login_logs`
--

CREATE TABLE `login_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `ip_address` varchar(100) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `method` varchar(10) DEFAULT NULL,
  `success` tinyint(1) DEFAULT NULL,
  `details` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `login_logs`
--

INSERT INTO `login_logs` (`id`, `user_id`, `timestamp`, `ip_address`, `user_agent`, `method`, `success`, `details`) VALUES
(1, 1, '2025-04-27 15:01:36', '127.0.0.1', NULL, NULL, NULL, NULL),
(2, 2, '2025-04-27 15:15:52', '127.0.0.1', NULL, NULL, NULL, NULL),
(3, 3, '2025-04-29 07:23:34', '127.0.0.1', NULL, NULL, NULL, NULL),
(4, 3, '2025-04-29 07:25:24', '127.0.0.1', NULL, NULL, NULL, NULL),
(5, 2, '2025-04-29 07:49:16', '127.0.0.1', NULL, NULL, NULL, NULL),
(6, 6, '2025-04-30 08:19:41', '127.0.0.1', NULL, NULL, NULL, NULL),
(7, 2, '2025-04-30 08:19:55', '127.0.0.1', NULL, NULL, NULL, NULL),
(8, 6, '2025-04-30 08:27:32', '127.0.0.1', NULL, NULL, NULL, NULL),
(9, 2, '2025-04-30 08:35:39', '127.0.0.1', NULL, NULL, NULL, NULL),
(10, 2, '2025-04-30 08:38:53', '127.0.0.1', NULL, NULL, NULL, NULL),
(11, 6, '2025-04-30 10:08:00', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36', 'manual', 1, 'Login successful'),
(12, NULL, '2025-04-30 10:09:03', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36', 'manual', 0, 'Invalid credentials'),
(13, 2, '2025-04-30 10:10:34', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36', 'github', 1, 'GitHub login successful'),
(14, NULL, '2025-04-30 10:17:35', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36', 'manual', 0, 'Invalid credentials'),
(15, NULL, '2025-04-30 10:31:42', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36', 'manual', 0, 'Invalid credentials'),
(16, NULL, '2025-04-30 10:32:41', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36', 'manual', 0, 'Invalid credentials'),
(17, NULL, '2025-04-30 10:35:42', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36', 'manual', 0, 'Invalid credentials'),
(18, 2, '2025-04-30 10:42:05', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36', 'github', 1, 'GitHub login successful'),
(19, 2, '2025-04-30 10:57:40', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36', 'github', 1, 'GitHub login successful');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `github_id` varchar(255) DEFAULT NULL,
  `auth_method` enum('manual','github') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `github_id`, `auth_method`, `created_at`) VALUES
(1, 'shadwa', 'shadwa@yahoo.com', '$2b$12$5KWPAy1PePtwZlpI7ZAWneFzXJ4mFLuvTqsOynl1k5vk9yg6x4yCa', NULL, 'manual', '2025-04-27 14:56:12'),
(2, 'shadwa729', '154993482@github.com', NULL, '154993482', 'github', '2025-04-27 15:15:52'),
(3, 'laila', 'laila@gmail.com', '$2b$12$sXG47lxQi/rHYpqi4qUxuu.QLbHD7nEWPwjzsfVQmqbYnxXNIIUz2', NULL, 'manual', '2025-04-29 07:21:36'),
(4, 'ahmed', 'ahmed@gmail.com', '$2b$12$bRsNwVZbcnx.Ce37z0sjres94aMrGy/nAsOu2xeyaDv01w2/XVK4K', NULL, 'manual', '2025-04-29 07:49:02'),
(5, 'alia', 'aliaali@gmail.com', '$2b$12$n4ofxf8uXY0pHv5TBAOgyOeO/oDK5e4RFOPzhji91RKBB0rO/vDuK', NULL, 'manual', '2025-04-30 08:15:51'),
(6, 'shams', 'shams@gmail.com', '$2b$12$FSdp9Lsld/wAzdKX2Fqpaetx/zz9NupFSxhfFaeSMwQ1WiwWlF4n6', NULL, 'manual', '2025-04-30 08:19:07');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `login_logs`
--
ALTER TABLE `login_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `login_logs`
--
ALTER TABLE `login_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `login_logs`
--
ALTER TABLE `login_logs`
  ADD CONSTRAINT `login_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
