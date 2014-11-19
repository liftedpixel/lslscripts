// Typing Override
// Stick in a transparent prim and attach to your head or something
// - Picks a random word from the list to display while typing
// - Cycles through random colors
// Jessica Pixel - liftedpixel.net - 11-19-2014

vector COLOR;
float SOLID = 1.0;

float TIMER = 0.1;
integer GetStatus;

list Words = ["Hrm...", "Typing...", "Indeed...", "Well...", "Thinking...", "You see...", "What about...", "Um..."];
string Word;


Typing()
{
    COLOR = < llFrand(1.0), llFrand(1.0), llFrand(1.0) >;
    llSetText ( Word, COLOR, SOLID );
}

NotTyping()
{
    Word = llList2String ( llListRandomize ( Words, 1 ), 0 );
    llSetText ( "", COLOR, SOLID );
}

default
{
    state_entry()
    {
        llSetTimerEvent ( TIMER );
    }
    
    timer()
    {
        GetStatus = llGetAgentInfo ( llGetOwner() );
        
        if ( GetStatus & AGENT_TYPING )
        {
            Typing();
        }
        
        else
        {
            NotTyping();
        }
    }
}
