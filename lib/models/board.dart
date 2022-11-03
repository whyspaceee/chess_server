class Board {
  String fenState;
  int gameNumber;
  bool inCheck = false;
  bool inCheckmate = false;

  Board(this.fenState, this.gameNumber);
}
