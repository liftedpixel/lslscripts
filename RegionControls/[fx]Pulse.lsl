default {
    
    state_entry() {
        
        llSetAlpha(0.0, ALL_SIDES);
        
        float x;

        for (x = 0.0; x < 1; x=x+0.00002) {
            llSetAlpha(x, ALL_SIDES);
        }
        
        state down;
    }
}

state down {
    
    state_entry() {
        
        llSetAlpha(1.0, ALL_SIDES);
        
        float x;

        for (x = 1.0; x > 0; x=x-0.00002) {
            llSetAlpha(x, ALL_SIDES);
        }
        
        state default;
    }
}