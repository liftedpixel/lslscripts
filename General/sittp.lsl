//Set the description of the object this script is in
//to the place you should teleported to (within the same region)
//Like this: <84,20,58>
//no sanity checking, script needs reset to update teleportPOS

vector homePOS;
vector teleportPOS;

init() {
  homePOS = llGetPos();
  teleportPOS = (vector)llGetObjectDesc();
  llSitTarget(<1,1,1>, <0,0,0,0>);
}

teleport() {
  llSetRegionPos(teleportPOS);
  llUnSit(llAvatarOnSitTarget());
  llSetRegionPos(homePOS);
}

default {
  state_entry() { init(); }

  changed(integer c) {
    if (c & CHANGED_LINK) {
      if (llAvatarOnSitTarget() != NULL_KEY) {
        llSetRegionPos(teleportPOS);
        llUnSit(llAvatarOnSitTarget());
      } else { llSetRegionPos(homePOS); }
    }
  }
}
