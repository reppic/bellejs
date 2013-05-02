function Animal(){
  this.makeNoise = function() {
    alert("-rustle-");
  };
}
function Wolf(){
  this.howl = function() {
    alert("Hooooooowlllllll!");
  };
  this.makeNoise = function() {
    this.howl();
  };
}
Wolf.prototype = new Animal();