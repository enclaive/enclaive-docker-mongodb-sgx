<?PHP
$alpha = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
foreach (mb_str_split($alpha) as $charOne) {
    foreach (mb_str_split($alpha) as $charTwo) {
        echo json_encode(["username"=>"testUsername".$charOne.$charTwo, "password"=>password_hash("testPassword".$charOne.$charTwo, PASSWORD_DEFAULT, ["cost"=>4])]) . "\n";
    }
}
