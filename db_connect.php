<?php
$conn = oci_connect('C##Project', '123456', 'localhost/orcl');
if (!$conn) {
    $e = oci_error();
    die("Lỗi kết nối Oracle: " . $e['message']);
}
?>