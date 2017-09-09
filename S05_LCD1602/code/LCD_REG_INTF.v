//--====================================================================================--
// THIS FILE IS PROVIDED IN SOURCE FORM FOR FREE EVALUATION, FOR EDUCATIONAL USE OR FOR 
// PEACEFUL RESEARCH.  DO NOT USE IT IN A COMMERCIAL PRODUCT . IF YOU PLAN ON USING THIS 
// CODE IN A COMMERCIAL PRODUCT, PLEASE CONTACT JUSTFORYOU200@163.COM TO PROPERLY LICENSE 
// ITS USE IN YOUR PRODUCT. 
// 
// Project      : Verilog Common Module
// File Name    : lcd_reg_intf.v
// Creator(s)   : justforyou200@163.com
// Date         : 2015/12/01
// Description  : A Reg Timing for LCD1602
//
// Modification :
// (1) Initial design  2015-12-01
//
//
//--====================================================================================--

module LCD_REG_INTF
    (  
        clk           ,
        rst_n         ,
        write         ,     
        read          ,
        wdata         ,
        reg_sel       ,
        rdata         ,
        ready         ,
        lcd_rs        ,
        lcd_rw        ,
        lcd_en        ,
        lcd_db_out    ,
        lcd_db_oen    ,
        lcd_db_in     
    );
 
//PARA   DECLARATION
parameter LCD_EN_SETUP_MIN = 16'd40   ; 
parameter LCD_EN_WIDTH_MIN = 16'd230  ; 
parameter LCD_EN_HOLD_MIN  = 16'd230  ; 

parameter LCD_EN_CYCLE_MIN = (LCD_EN_SETUP_MIN + LCD_EN_WIDTH_MIN + LCD_EN_HOLD_MIN)  ; 

//INPUT  DECLARATION
input                           clk          ; //LCD clock 
input                           rst_n        ; //LCD clock reset (0: reset)
input                           write        ; //LCD write enable(1: enable), only one clock pulse
input                           read         ; //LCD read  enable(1: enable), only one clock pulse
input                           reg_sel      ; //LCD DATA SEL: 0-COMMAND | 1-DATA; 
input   [7:0]                   wdata        ; //LCD write data
input   [7:0]                   lcd_db_in    ; //LCD INTF SIGNAL

//OUTPUT DECLARATION
output  [7:0]                   rdata        ; //LCD READ data
output                          ready        ; //LCD ACCESS Ready
output                          lcd_rs       ; //LCD INTF SIGNAL
output                          lcd_rw       ; //LCD INTF SIGNAL
output                          lcd_en       ; //LCD INTF SIGNAL
output  [7:0]                   lcd_db_out   ; //LCD INTF SIGNAL
output                          lcd_db_oen   ; //LCD INTF SIGNAL

//--========================MODULE SOURCE CODE==========================--
reg     [15:0]                  lcd_timing_cnt  ;
wire                            lcd_wr_cmd      ;
wire                            lcd_cmd_idle    ;
reg                             lcd_rs          ;
reg                             lcd_rw          ;
reg                             lcd_db_oen      ;
reg                             lcd_en          ;
reg     [7:0]                   lcd_db_out      ;
reg     [7:0]                   rdata           ;

//--=========================================--
// LCD TIMING COUNT :
// Initial Value LCD_EN_CYCLE_MIN ; It count 
// from 0 to LCD_EN_CYCLE_MIN when one access.
//--=========================================--
assign lcd_wr_cmd   = (write | read); 
assign lcd_cmd_idle = (lcd_timing_cnt >= LCD_EN_CYCLE_MIN) ;

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        lcd_timing_cnt <= LCD_EN_CYCLE_MIN ;
    else if (lcd_wr_cmd & lcd_cmd_idle)
        lcd_timing_cnt <= 16'b0 ;
    else if (lcd_timing_cnt < LCD_EN_CYCLE_MIN)    
        lcd_timing_cnt <= lcd_timing_cnt + 16'b1 ;       
end

//--=========================================--
// LCD INTERFACE SIGNAL :
// RS   : 0-COMMAND | 1-DATA; 
// RW   : 0-WRITE   | 1-READ; 
// E    : 0-Disable | 1-ENABLE;
//--=========================================--
always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        lcd_rs <= 1'b0 ;  
    else if (lcd_wr_cmd & lcd_cmd_idle)
        lcd_rs <= reg_sel ;           
end

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) 
    begin
        lcd_rw     <= 1'b0 ; 
        lcd_db_oen <= 1'b1 ;    
    end        
    else if (write  & lcd_cmd_idle)
    begin
        lcd_rw     <= 1'b0 ; 
        lcd_db_oen <= 1'b0 ;    
    end          
    else if (read  & lcd_cmd_idle)
    begin
        lcd_rw     <= 1'b1 ; 
        lcd_db_oen <= 1'b1 ;    
    end                 
end

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        lcd_en <= 1'b0 ;  
    else if (lcd_timing_cnt <= LCD_EN_SETUP_MIN)
        lcd_en <= 1'b0 ;  
    else if (lcd_timing_cnt >= LCD_EN_SETUP_MIN + LCD_EN_WIDTH_MIN)
        lcd_en <= 1'b0 ;          
    else
        lcd_en <= 1'b1 ;            
end

//--=========================================--
// lcd_db_out :
// Update wdata when write enbale and keep it 
// till en cycle end.
//--=========================================--
always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        lcd_db_out <= 8'b0 ;
    else if (write  & lcd_cmd_idle)
        lcd_db_out <= wdata;   
    else if (lcd_timing_cnt >= LCD_EN_CYCLE_MIN)
        lcd_db_out <= 8'b0 ;               
end

//--=========================================--
// rdata :
// Update rdata when lcd en cycle end.
//--=========================================--
always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rdata <= 8'h0 ;
    else if (read  & lcd_cmd_idle) //Specify an Error Code here.
        rdata <= 8'hFF;   
    else if (lcd_timing_cnt >= LCD_EN_CYCLE_MIN)
        rdata <= lcd_db_in ;               
end

endmodule