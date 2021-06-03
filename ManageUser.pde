class ManageUser{
  JSONArray appData;
  String path;
  
  ManageUser(JSONArray appData, String path){
    this.appData = appData;
    this.path = path;
  }
  
  User login(String userName){
    User user;
    for(int i = 0; i < appData.size(); i++){
      JSONObject userData = appData.getJSONObject(i);
      String name = userData.getString("name");
      
      if(name.equals(userName)){
        user = new User(userData.getInt("id"), name);
        JSONArray scores = userData.getJSONArray("scores");
        user.setScoreOf(scores.getInt(0), "Sudoku");
        user.setScoreOf(scores.getInt(1), "Coins");
        user.setScoreOf(scores.getInt(2), "Memory");
        user.setProfileImage(userData.getString("profileImage"));
      
        return user;
      }
    }
  
    user = new User(appData.size(), userName);
    saveUser(user);
    return user;
  }
  

  void saveUser(User user){
    JSONObject userData = new JSONObject();
    
    int ID = user.getID();
    
    JSONArray scores = new JSONArray();
    scores.setInt(0, user.getScoreOf("Sudoku"));
    scores.setInt(1, user.getScoreOf("Coins"));
    scores.setInt(2, user.getScoreOf("Memory"));
    
    userData.setJSONArray("scores", scores);
    userData.setString("profileImage", user.getProfileImage());
    userData.setString("name", user.getName());
    userData.setInt("id", ID);
    
    appData.setJSONObject(ID, userData);
    
    saveJSONArray(appData, path);
  }
  
 void removeUser(User user){
   int id = user.getID();
   appData.remove(id);
   
   for(; id < appData.size(); id++){
     JSONObject userData = appData.getJSONObject(id);
     userData.setInt("id", id);
    }
   
    saveJSONArray(appData, path);
 }

}
