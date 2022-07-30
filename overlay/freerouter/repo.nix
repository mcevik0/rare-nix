{ fetchFromGitHub }:

{
  version = "22.7.30";

  src = fetchFromGitHub {
    owner = "rare-freertr";
    repo = "freeRtr";
    rev = "556f3f108fe644681aac0adb6e533e844f47361e";
    sha256 = "1952jlrbzprnzfx6q15jb5pf79yan3az7ssizzf0kd5541ab8k35";
  };
}
