CREATE TABLE `phone_gallery` (
     `citizenid` VARCHAR(255) NOT NULL , 
     `image` VARCHAR(255) NOT NULL ,
     `date` timestamp NULL DEFAULT current_timestamp()
     ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;