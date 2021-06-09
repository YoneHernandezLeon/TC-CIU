import java.io.File;

class ManageUser{
  JSONArray appData;
  String path;
  
  ManageUser(JSONArray appData, String path){
    this.appData = appData;
    this.path = path;
  }
  
  //Devuelve el usuario con los valores que este tenía la última vez que salió si coincide con el parámetro userName, 
  //en caso contrario crea un nuevo usuario y lo guarda en el fichero especificado en path
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
      
        JSONArray preferences = userData.getJSONArray("preferences");
        user.setPreference(preferences.getInt(0), "Volume");
        user.setPreference(preferences.getInt(1), "Sound");
        user.setPreference(preferences.getInt(2), "Palette");
        user.setProfileImage(userData.getString("profileImage"));
      
        return user;
      }
    }
  
    user = new User(appData.size(), userName);
    saveUser(user);
    return user;
  }
  
  //guarda el usuario en el fichero especificado en path
  void saveUser(User user){
    JSONObject userData = new JSONObject();
    
    int ID = user.getID();
    
    JSONArray scores = new JSONArray();
    scores.setInt(0, user.getScoreOf("Sudoku"));
    scores.setInt(1, user.getScoreOf("Coins"));
    scores.setInt(2, user.getScoreOf("Memory"));
    
    JSONArray preferences = new JSONArray();
    preferences.setInt(0, user.getPreference("Volume"));
    preferences.setInt(1, user.getPreference("Sound"));
    preferences.setInt(2, user.getPreference("Palette"));
    
    userData.setInt("id", ID);
    userData.setString("name", user.getName());
    userData.setString("profileImage", user.getProfileImage());
    userData.setJSONArray("scores", scores);
    userData.setJSONArray("preferences", preferences);
    
    appData.setJSONObject(ID, userData);
    
    saveJSONArray(appData, path);
  }
  
 //Elimina el usuario del fichero especificado en path, resta uno al id de los demás usuarios que estuvieran por
 //delante de ese y en caso de no tener la imagen de perfil por defecto, esta también será elminada
 void removeUser(User user){
   int id = user.getID();
   String fileName = user.getProfileImage();
   if (!fileName.equals("img/users/default.jpeg")){
     File f = sketchFile(fileName);
     f.delete();
   }appData.remove(id);
   
   for(; id < appData.size(); id++){
     JSONObject userData = appData.getJSONObject(id);
     userData.setInt("id", id);
    }
   
    saveJSONArray(appData, path);
 }

}
