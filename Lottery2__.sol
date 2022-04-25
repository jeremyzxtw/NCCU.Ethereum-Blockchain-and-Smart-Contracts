pragma solidity ^0.5.0;

contract Lottery{
    uint public phase=1;
    uint public player_num_temp=0; 
    uint public winner_num_temp=0;
    struct lottery_num{
        uint one;
        uint two;
        uint three;
        uint four;
        uint five;
        uint six;
        
    }
    
    mapping(uint => lottery_num) public lottery;
    
    mapping(address => mapping(uint=>mapping(uint=> lottery_num))) public buy;
    mapping(uint => uint) public players_count;//該期客戶總共數量
    mapping(uint => uint) public winners_count;//該期贏家總共數量
    mapping(address => mapping(uint =>uint)) public user_phase_count;//客戶第n期買幾次
    mapping(uint => address payable[25]) public users_address_everyround;//每一期參與的帳號;
    mapping(uint=> address payable[25]) public winner_address_everyround;
    
    
    function drawing(uint a,uint b,uint c,uint d,uint e,uint f) public payable {
        lottery[phase].one=a;
        lottery[phase].two=b;
        lottery[phase].three=c;
        lottery[phase].four=d;
        lottery[phase].five=e;
        lottery[phase].six=f;
        if(players_count[phase]==0)
        {
            phase=phase+1;
        }
        else
        {
            findwinner();
            if(winners_count[phase]==0)
            {
                phase=phase+1;
                player_num_temp=0;
            }
            else
            {
                findwinner2();
                phase=phase+1;
                player_num_temp=0;
                winner_num_temp=0;
            }
        }
        
    }
   
    
    function findwinner() public 
    {
        winners_count[phase]==0;
        for(uint i=0 ;i< player_num_temp;i++)
        {
            for(uint k=0;k<user_phase_count[users_address_everyround[phase][i]][phase];k++)
            {
                if(buy[users_address_everyround[phase][i]][phase][k].one==lottery[phase].one && buy[users_address_everyround[phase][i]][phase][k].two==lottery[phase].two && buy[users_address_everyround[phase][i]][phase][k].three==lottery[phase].three && buy[users_address_everyround[phase][i]][phase][k].four==lottery[phase].four && buy[users_address_everyround[phase][i]][phase][k].five==lottery[phase].five  && buy[users_address_everyround[phase][i]][phase][k].six==lottery[phase].six)
                {
                winner_address_everyround[phase][winners_count[phase]]=users_address_everyround[phase][i];
                winners_count[phase]+=1;
                winner_num_temp+=1;
                }
                
            }
            
        }
        
    }
    
    
    function win_lottery(address payable dest,uint winning_prize) public payable
    {
        dest.transfer(winning_prize);
    }
    
    
    function findwinner2() public payable
    {
        uint prize = uint(address(this).balance)/winner_num_temp;
        for(uint i=0; i< winners_count[phase];i++)
        {
            win_lottery(winner_address_everyround[phase][i],prize);
        }
    }
    
    function buying(uint a,uint b,uint c,uint d,uint e,uint f) public payable {
        require(msg.value>=100000000000000000,"No money mo lottery, poor ass.");
        require(a<=10 && a>=1,"please selcet the number between 1-10.");
        require(b<=10 && a>=1,"please selcet the number between 1-10.");
        require(c<=10 && a>=1,"please selcet the number between 1-10.");
        require(d<=10 && a>=1,"please selcet the number between 1-10.");
        require(e<=10 && a>=1,"please selcet the number between 1-10.");
        require(f<=10 && a>=1,"please selcet the number between 1-10.");
        buy[msg.sender][phase][user_phase_count[msg.sender][phase]].one=a;
        buy[msg.sender][phase][user_phase_count[msg.sender][phase]].two=b;
        buy[msg.sender][phase][user_phase_count[msg.sender][phase]].three=c;
        buy[msg.sender][phase][user_phase_count[msg.sender][phase]].four=d;
        buy[msg.sender][phase][user_phase_count[msg.sender][phase]].five=e;
        buy[msg.sender][phase][user_phase_count[msg.sender][phase]].six=f;
        if(user_phase_count[msg.sender][phase]==0)
        {
            users_address_everyround[phase][player_num_temp]=msg.sender;
            player_num_temp+=1;
        }
        user_phase_count[msg.sender][phase]=user_phase_count[msg.sender][phase]+1;
        players_count[phase]=players_count[phase]+1;

    }
    
    
    
    
    
    //以下會顯示資訊
    
    function view_balance() public view returns(uint balance1)
    {
        balance1 = address(this).balance;
    }
    
    function view_phase() public view returns(uint what_phase)
    {
        what_phase = phase;
    }
    
    
    function view_num_last_round() public view returns(uint a,uint b,uint c,uint d,uint e,uint f)
    {
        a = lottery[phase-1].one;
        b = lottery[phase-1].two;
        c = lottery[phase-1].three;
        d = lottery[phase-1].four;
        e = lottery[phase-1].five;
        f = lottery[phase-1].six;
        
    }
    
    function () external payable 
    {
        revert();
    }
    

}