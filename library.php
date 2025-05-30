<?php
session_start();
include 'db_connect.php';

// Lấy tất cả sách từ bảng lib kèm số bản đang thuê (ntreturned)
$sql = "
SELECT 
  l.bookname, l.author, l.publication, l.noofcopies,
  NVL((
    SELECT COUNT(*) FROM subscription s 
    JOIN books b ON s.bookno = b.bookno
    WHERE b.bookname = l.bookname AND s.status = 'ntreturned'
  ), 0) AS rented_count
FROM lib l
ORDER BY l.bookname";

$stid = oci_parse($conn, $sql);
oci_execute($stid);

$books = [];
while ($row = oci_fetch_assoc($stid)) {
    // Tính số bản có thể thuê (copies_available)
    $copiesAvailable = $row['NOOFCOPIES'] - $row['RENTED_COUNT'];
    if ($copiesAvailable < 0) {
        $copiesAvailable = 0;
    }
    $row['COPIES_AVAILABLE'] = $copiesAvailable;
    $books[] = $row;
}

// Hàm lấy đường dẫn ảnh theo tên sách (bạn chuẩn bị ảnh trong folder images)
function getBookImage($bookname) {
    $file = 'images/' . strtolower(str_replace(' ', '_', $bookname)) . '.jpg';
    if (file_exists($file)) {
        return $file;
    }
    return 'images/default_book.jpg';
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Library</title>
    <style>
        body {
            background-color: #000;
            color: #fff;
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        h1 {
            text-align: center;
            margin-bottom: 30px;
        }
        .book-list {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 24px;
        }
        .book-card {
            background: #111;
            width: 180px;
            border-radius: 8px;
            box-shadow: 0 0 8px #fff;
            text-align: center;
            padding: 10px;
        }
        .book-card img {
            width: 150px;
            height: 220px;
            object-fit: cover;
            border-radius: 4px;
        }
        .book-title {
            font-weight: bold;
            margin: 10px 0 5px 0;
            font-size: 16px;
        }
        .book-author, .book-publication, .book-copies {
            font-size: 12px;
            margin-bottom: 4px;
        }
        .rent-btn {
            margin-top: 10px;
            background-color: #fff;
            color: #000;
            padding: 8px 12px;
            border: none;
            border-radius: 4px;
            font-weight: bold;
            cursor: pointer;
            width: 100%;
            font-size: 14px;
            transition: background-color 0.3s ease;
        }
        .rent-btn:hover {
            background-color: #ccc;
        }
        a.logout {
            position: fixed;
            top: 20px;
            right: 20px;
            color: #fff;
            text-decoration: underline;
            font-size: 14px;
        }
        /* Bạn cũng có thể sửa vị trí icon nếu muốn */
        .my-rented-books {
            position: fixed;
            top: 20px;
            left: 20px;
        }
    </style>
</head>
<body>

<div class="my-rented-books">
    <a href="my_rented_books.php" title="My Rented Books">
        <img src="images/My_rented_books_icon.jpg" alt="My Rented Books" style="max-height: 60px; cursor: pointer; border: 2px solid #fff; border-radius: 8px; padding: 4px;">
    </a>
</div>

<h1>Library</h1>

<?php if (isset($_SESSION['user'])): ?>
    <a class="logout" href="logout.php">Logout (<?php echo htmlspecialchars($_SESSION['user']); ?>)</a>
<?php else: ?>
    <a class="logout" href="login.php">Login</a>
<?php endif; ?>

<div class="book-list">
    <?php foreach ($books as $book): ?>
        <div class="book-card">
            <img src="<?php echo getBookImage($book['BOOKNAME']); ?>" alt="<?php echo htmlspecialchars($book['BOOKNAME']); ?>">
            <div class="book-title"><?php echo htmlspecialchars($book['BOOKNAME']); ?></div>
            <div class="book-author">Author: <?php echo htmlspecialchars($book['AUTHOR']); ?></div>
            <div class="book-publication">Publisher: <?php echo htmlspecialchars($book['PUBLICATION']); ?></div>
            <div class="book-copies">Copies available: <?php echo htmlspecialchars($book['COPIES_AVAILABLE']); ?></div>
            <form method="get" action="rent_book.php">
                <input type="hidden" name="bookname" value="<?php echo htmlspecialchars($book['BOOKNAME']); ?>">
                <button class="rent-btn" type="submit" <?php echo ($book['COPIES_AVAILABLE'] == 0) ? 'disabled' : ''; ?>>
                    <?php echo ($book['COPIES_AVAILABLE'] == 0) ? 'Not Available' : 'Rent Book'; ?>
                </button>
            </form>
        </div>
    <?php endforeach; ?>
</div>

</body>
</html>
