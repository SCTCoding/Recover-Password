--
--  AppDelegate.applescript
--  Recover Password
--
--  Created by FOSS on 2/20/19.
--  Copyright © 2019 SCTCoding. All rights reserved.
--

script AppDelegate
	property parent : class "NSObject"
    
    property basePath : missing value
    
    property passReturn : missing value
    
    property autologinuser : missing value
    
	
	-- IBOutlets
	property theWindow : missing value
	
	on applicationWillFinishLaunching_(aNotification)
		-- Insert code here to initialize your application before any files are opened
        set the stringValue of basePath to "/Volumes/Macintosh\\ HD"
	end applicationWillFinishLaunching_
	
	on applicationShouldTerminate_(sender)
		-- Insert code here to do any housekeeping before your application quits 
		return current application's NSTerminateNow
	end applicationShouldTerminate_
    

    on passrec_(sender)
        set loginPath to basePath's stringValue()
        
        set autouser to do shell script "defaults read " & loginPath & "/Library/Preferences/com.apple.loginwindow.plist autoLoginUser" with administrator privileges
        
        set the stringValue of autologinuser to autouser
        
        set loginPath to basePath's stringValue()
        
        -- XOR Function
        -- Obtained from here:
        -- http://www.codeproject.com/Tips/470308/XOR-Hex-Strings-in-Linux-Shell-Script
        -- Author is Sanjay1982 (see http://www.codeproject.com/Members/Sanjay1982)
        
        set currentpw to do shell script "target=$(xxd -l 240 -ps -u " & loginPath & "/private/etc/kcpassword); mn=7D895223D2BCDDEAA3B91F7D895223D2BCDDEAA3B91F7D895223D2BCDDEAA3B91F7D895223D2BCDDEAA3B91F;
        function  xor() { local res=(`echo \"$1\" | sed \"s/../0x& /g\"`); shift 1; while [[ \"$1\" ]]; do
        local one=(`echo \"$1\" | sed \"s/../0x& /g\"`); local count1=${#res[@]}; if [ $count1 -lt ${#one[@]} ];
        then count1=${#one[@]}; fi; for (( i = 0; i < $count1; i++ ));
        do res[$i]=$((${one[$i]:-0} ^ ${res[$i]:-0}));
        done; shift 1; done; printf \"%02x\" \"${res[@]}\"; }; recpw=$(xor $target $mn | sed 's/00.*//' | xxd -r -p); echo $recpw;" with administrator privileges
        
      -- Blank password handler
       if currentpw is "" then
        set the stringValue of passReturn to "The user has no password."
       else
        set the stringValue of passReturn to currentpw
    end if
    
    end passrec_

    on quit_(sender)
        quit
    end quit_
    
    on getkeychain_(sender)
        set loginPath to basePath's stringValue()
        do shell script "auser=$(defaults read " &loginPath& "/Library/Preferences/com.apple.loginwindow.plist autoLoginUser); mkdir /Users/Shared/Keychain-$auser; sudo cp " &loginPath& "/Users/$auser/Library/Keychains/login.key* /Users/Shared/Keychain-$auser/; open /Users/Shared" with administrator privileges
    end getkeychain_

end script
