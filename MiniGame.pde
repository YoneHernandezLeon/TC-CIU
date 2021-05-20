abstract class MiniGame {
  int score = 0;
  
  abstract void display();
  
  int getScore(){
    return score;
  }
  
  
  abstract void control(int keyPress);
  abstract void control(int x, int y, boolean left);
}
