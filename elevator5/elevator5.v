module elevator5(LEDR,SW,KEY, CLOCK_50, HEX2, HEX3,HEX0, HEX1, HEX4, HEX5);

	input [9:0] SW;
   input [3:0] KEY;
	output[9:0] LEDR;
	input CLOCK_50;
	output[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	wire [1:0] destination1, destination2;
	wire [1:0] current_floor1, current_floor2;

	//wire [25:0] rate_out1,rate_out2;
	wire [2:0] rate_out_up1,rate_out_down1;
	wire [2:0] rate_out_up2,rate_out_down2;

	//wire [27:0] rate_door1;
	wire[4:0] rate_door1, rate_door2;
	wire move_up1, move_down1,door_open1,statedelay1;
	wire move_up2, move_down2,door_open2,statedelay2;
	
	wire enable_11,enable_22;

	wire displayen_up1, displayen_down1;
	wire displayen_up2, displayen_down2;
	
	wire floor0,floor1,floor2,floor3;
	
	wire floor0ine1, floor1ine1, floor2ine1, floor3ine1;
	wire floor0ine2, floor1ine2, floor2ine2, floor3ine2;

	wire control_en1,control_en2;
	wire idle1, idle2;
	
   register fl0(.d(KEY[0]),
	             .floorin1(floor0ine1),
					 .floorin2(floor0ine2),
						 .clk(CLOCK_50),
						 .reset(SW[9]),
						 .q(floor0));
						 
	register fl1(.d(KEY[1]),
		             .floorin1(floor1ine1),
						 .floorin2(floor1ine2),
						 .clk(CLOCK_50),
						 .reset(SW[9]),
						 .q(floor1));
						 
	register fl2(.d(KEY[2]),
						 .floorin1(floor2ine1),
						 .floorin2(floor2ine2),
						 .clk(CLOCK_50),
						 .reset(SW[9]),
						 .q(floor2));
						 
	register fl3(.d(KEY[3]),
		             .floorin1(floor3ine1),
						 .floorin2(floor3ine2),
						 .clk(CLOCK_50),
						 .reset(SW[9]),
						 .q(floor3));
						 
	assign LEDR[0] = floor0;
	assign LEDR[1] = floor1;
	assign LEDR[2] = floor2;
	assign LEDR[3] = floor3;
	
	control c1(.clock(CLOCK_50),
				  .reset(SW[9]),
				  .move_up(move_up1),
				  .move_down(move_down1),
				  .current_floor(current_floor1),
				  .destination(destination1),
				  .door_open(door_open1),
				  .statedelay(statedelay1),
				  .idlesignal(idle1),
				  .enable(control_enable1),
				  .floor0in(floor0ine1),
				  .floor1in(floor1ine1),
				  .floor2in(floor2ine1),
				  .floor3in(floor3ine1),
				  .floor0(floor0),
				  .floor1(floor1),
				  .floor2(floor2),
				  .floor3(floor3),
				  .enable_set(enable_11));
	
	control c2(.clock(CLOCK_50),
				  .reset(SW[9]),
				  .move_up(move_up2),
				  .move_down(move_down2),
				  .current_floor(current_floor2),
				  .destination(destination2),
				  .door_open(door_open2),
				  .statedelay(statedelay2),
				  .idlesignal(idle2),
				  .enable(control_enable2),
				  .floor0in(floor0ine2),
				  .floor1in(floor1ine2),
				  .floor2in(floor2ine2),
				  .floor3in(floor3ine2),
				  .floor0(floor0),
				  .floor1(floor1),
				  .floor2(floor2),
				  .floor3(floor3),
				  .enable_set(enable_22));
				  
	control_master cm(.current_floor1(current_floor1),
							.current_floor2(current_floor2),
							.destination1(destination1),
							.destination2(destination2),
							.idle1(idle1),
							.idle2(idle2),
							.enable1(control_enable1),
							.enable2(control_enable2),
							.floor0(floor0),
							.floor1(floor1),
							.floor2(floor2),
							.floor3(floor3),
							.reset(SW[9]),
							.clock(CLOCK_50),
							.move_up1(move_up1),
							.move_up2(move_up2),
							.move_down1(move_down1),
							.move_down2(move_down2),
							.enable11(enable_11),
							.enable22(enable_22));
							
	ratedivider r0(.dividerenable(move_up1),
						 .clock(CLOCK_50),
					    .reset(SW[9]),
						 .q(rate_out_up1),
						 //.load(26'b1011111010111100001000000));
						 .load(3'b101));
		
	ratedivider r1(.dividerenable(move_down1),
						 .clock(CLOCK_50),
					    .reset(SW[9]),
						 .q(rate_out_down1),
						 //.load(26'b1011111010111100001000000));
						 .load(3'b101));
	
	ratedividerdoors r2(.ratedoorenable(door_open1),
						 .clock(CLOCK_50),
					    .reset(SW[9]),
						 .q(rate_door1),
						 //.load(28'b1000111100001101000110000000));
						 .load(5'b11101));
	
	ratedivider r3(.dividerenable(move_up2),
						 .clock(CLOCK_50),
					    .reset(SW[9]),
						 .q(rate_out_up2),
						 //.load(26'b1011111010111100001000000));
						 .load(3'b101));
		
	ratedivider r4(.dividerenable(move_down2),
						 .clock(CLOCK_50),
					    .reset(SW[9]),
						 .q(rate_out_down2),
						 //.load(26'b1011111010111100001000000));
						 .load(3'b101));
	
	ratedividerdoors r5(.ratedoorenable(door_open2),
						 .clock(CLOCK_50),
					    .reset(SW[9]),
						 .q(rate_door2),
						 //.load(28'b1000111100001101000110000000));
						 .load(5'b11101));
		
	//assign displayen_up = (rate_out1 == 26'b00000000000000000000000000) ? 1'b1 : 1'b0;
	assign displayen_up1 = (rate_out_up1 == 3'b000) ? 1'b1 : 1'b0;
	//assign displayen_down = (rate_out2 == 26'b00000000000000000000000000) ? 1'b1 : 1'b0;
	assign displayen_down1 = (rate_out_down1 == 3'b000) ? 1'b1 : 1'b0;
	
	assign displayen_up2 = (rate_out_up2 == 3'b000) ? 1'b1 : 1'b0;
	assign displayen_down2 = (rate_out_down2 == 3'b000) ? 1'b1 : 1'b0;



	datapath data1(.clock(CLOCK_50),
						.move_up(displayen_up1),
						.move_down(displayen_down1),
						.destination(destination1),
						.current_floor(current_floor1),
						.reset(SW[9]));
	
	datapath data2(.clock(CLOCK_50),
						.move_up(displayen_up2),
						.move_down(displayen_down2),
						.destination(destination2),
						.current_floor(current_floor2),
						.reset(SW[9]));
	
	decoder_right dc0(.doorenable(door_open1),
								 .s0(HEX0[0]),
								 .s1(HEX0[1]),
								 .s2(HEX0[2]),
								 .s3(HEX0[3]),
								 .s4(HEX0[4]),
								 .s5(HEX0[5]),
								 .s6(HEX0[6]));
			
	decoder_left dc1(.doorenable(door_open1),
								 .s0(HEX1[0]),
								 .s1(HEX1[1]),
								 .s2(HEX1[2]),
								 .s3(HEX1[3]),
								 .s4(HEX1[4]),
								 .s5(HEX1[5]),
								 .s6(HEX1[6]));
								 
	decoder dc2(	.a(1'b0),
					   .b(1'b0),
						.c(current_floor1[1]),
						.d(current_floor1[0]),
						.s0(HEX2[0]),
						.s1(HEX2[1]),
						.s2(HEX2[2]),
						.s3(HEX2[3]),
						.s4(HEX2[4]),
						.s5(HEX2[5]),
						.s6(HEX2[6]));
	
	decoder_right dc4(.doorenable(door_open2),
								 .s0(HEX4[0]),
								 .s1(HEX4[1]),
								 .s2(HEX4[2]),
								 .s3(HEX4[3]),
								 .s4(HEX4[4]),
								 .s5(HEX4[5]),
								 .s6(HEX4[6]));
			
	decoder_left dc5(.doorenable(door_open2),
								 .s0(HEX5[0]),
								 .s1(HEX5[1]),
								 .s2(HEX5[2]),
								 .s3(HEX5[3]),
								 .s4(HEX5[4]),
								 .s5(HEX5[5]),
								 .s6(HEX5[6]));
								 
	decoder dc3(	.a(1'b0),
						.b(1'b0),
						.c(current_floor2[1]),
						.d(current_floor2[0]),
						.s0(HEX3[0]),
						.s1(HEX3[1]),
						.s2(HEX3[2]),
						.s3(HEX3[3]),
						.s4(HEX3[4]),
						.s5(HEX3[5]),
						.s6(HEX3[6]));
		
	//assign statedelay = (rate_door1 == 28'b0000000000000000000000000000) ? 1'b1 : 1'b0;
	assign statedelay1 = (rate_door1 == 5'b00000) ? 1'b1 : 1'b0;
	assign statedelay2 = (rate_door2 == 5'b00000) ? 1'b1 : 1'b0;
endmodule

module datapath(clock,move_up,move_down,destination,reset,current_floor);
		input clock,move_up,move_down,reset;
		input [1:0] destination;
		output reg [1:0] current_floor;
	
		always @(posedge clock)
						begin
						  if (reset == 1'b1)
								begin
								current_floor <= 2'b00;
								end
						  else if (move_up == 1'b1 && (current_floor < destination))
									current_floor <= current_floor + 2'b01;
						  else if(move_down == 1'b1 && (current_floor > destination))
									current_floor <= current_floor - 2'b01;				
						end
endmodule

module ratedivider(dividerenable,clock,reset,q,load);
	//input [25:0] load;
	input[2:0] load;
	input dividerenable, clock, reset;
	//output reg [25:0] q;
	output reg [2:0] q;
	
	always @(posedge clock)
	begin
		if (reset == 1'b1)
				q <= load;
		//else if (q == 26'b000000000000000000000000)		
		else if (q == 3'b000)
				q <= load;
		else if (dividerenable == 1'b1)
				q <= q - 1'b1;
	end
endmodule

module decoder(a, b, c, d, s0, s1, s2, s3, s4, s5, s6);

	input a;
	input b;
	input c;
	input d;
	output s0;
	output s1;
	output s2;
	output s3;
	output s4;
	output s5;
	output s6;
	
	//Reduced boolean expression for each segment
		assign s0 = ~a & ~b & ~c & d |
					~a & b & ~c & ~d |
					a & ~b & c & d |
					a & b & ~c & d;
				
		assign s1 =	b & c & ~d |
					a & c & d |
					a & b & ~d |
					~a & b & ~c & d;
					
		assign s2 = a & b & ~d |
					a & b & c |
					~a & ~b & c & ~d;
	
		assign s3 = b & c & d |
					~a & ~b & ~c & d |
					~a & b & ~c & ~d |
					a & ~b & c & ~d;

		assign s4 = ~a & d |
					~b & ~c & d |
					~a & b & ~c;

		assign s5 = ~a & ~b & d |
					~a & ~b & c |
					~a & c & d |
					a & b & ~c & d;
			
		assign s6 = ~a & ~b & ~c |
					~a & b & c & d |
					a & b & ~c & ~d;
			
endmodule

module control(clock,go,reset,destination,current_floor,move_up,move_down,door_open,statedelay,enable_set, idlesignal, floor0in, floor1in,floor2in,floor3in, floor1, floor2, floor3,floor0,enable);
			
			
	 input clock,go,reset,statedelay,enable, floor1,floor2,floor3,floor0;
	 input[1:0] current_floor,destination;
	 output reg move_up,move_down,door_open,idlesignal,floor0in, floor1in,floor2in,floor3in,enable_set;
	 reg[1:0] current_state, next_state;
	 
    localparam idle=3'd0, moveup=3'd1, movedown=3'd2, dooropen=3'd3;
			
    //state table
    always@(*)
    begin
          case(current_state)
                  idle: begin
						   if(destination < current_floor)
								  next_state= movedown;
							else if(destination > current_floor)
								  next_state= moveup;
							else if(current_floor == destination && enable == 1'b1)
								  next_state = dooropen;
							else if (enable == 1'b0) 
							  next_state = idle;
							else
							     next_state = idle;
						end
						moveup: next_state = (current_floor==destination) ? dooropen : moveup;
//						moveup: begin
//							if (current_floor == 2'b00 && floor0 == 1'b1)
//								next_state = dooropen;
//							else if (current_floor == 2'b01 && floor1 == 1'b1)
//								next_state = dooropen;
//							else if (current_floor == 2'b10 && floor2 == 1'b1)
//								next_state = dooropen;
//							else if (current_floor == 2'b11 && floor3 == 1'b1)
//								next_state = dooropen;
//							else
//								next_state = moveup;
//							end
						movedown: next_state = (current_floor==destination) ? dooropen : movedown;
//						movedown: begin
//							if (current_floor == 2'b00 && floor0 == 1'b1)
//								next_state = dooropen;
//							else if (current_floor == 2'b01 && floor1 == 1'b1)
//								next_state = dooropen;
//							else if (current_floor == 2'b10 && floor2 == 1'b1)
//								next_state = dooropen;
//							else if (current_floor == 2'b11 && floor3 == 1'b1)
//								next_state = dooropen;
//							else
//								next_state = movedown;
//							end
						dooropen: next_state = (statedelay==1'b1) ? idle : dooropen;
           endcase
    end
	 
	 //signals for each state
	 always @(*)
	 begin
		 door_open= 1'b0;
		 floor0in = 1'b0;
		 floor1in = 1'b0;
		 floor2in = 1'b0;
		 floor3in = 1'b0;
		 case(current_state)
		     idle:begin
			  	 floor0in = 1'b0;
				 floor1in = 1'b0;
				 floor2in = 1'b0;
				 floor3in = 1'b0;
				 door_open =1'b0;
				 move_up=1'b0;
				 move_down=1'b0;
				 idlesignal = 1'b1;
				 enable_set=1'b0;

			  end
			  moveup:begin
			  	 door_open=1'b0;
			    move_up=1'b1;
				 move_down=1'b0;
				 idlesignal = 1'b0;
				 enable_set=1'b0;
				 
			  end
			  movedown:begin
			  	 door_open=1'b0;
			    move_up=1'b0;
				 move_down=1'b1;
				 idlesignal = 1'b0;
				 enable_set=1'b0;
			
			  end
			  dooropen:begin
			     door_open=1'b1;
				  enable_set=1'b1;
				 
				  if (current_floor == destination)
						move_up=1'b0;
				      move_down=1'b0;
				      idlesignal = 1'b0;
				  if (current_floor== 2'b00 )
					 floor0in = 1'b1;
				  else if (current_floor == 2'b01)
					 floor1in = 1'b1;
				  else if (current_floor == 2'b10)
					 floor2in = 1'b1;
				  else if (current_floor == 2'b11)
					 floor3in = 1'b1;
			  end
		endcase
    end

    //state register
    always@(posedge clock)
    begin
		if(reset) begin
			current_state <= idle;
			end
		else
			current_state <= next_state;
    end
endmodule

module decoder_right(doorenable, s0, s1, s2, s3, s4, s5, s6);
	
	input doorenable;
	output s0;
	output s1;
	output s2;
	output s3;
	output s4;
	output s5;
	output s6;
	reg s1, s2, s4, s5;
	
	assign s0 = 1'b1;
	assign s3 = 1'b1;
	assign s6 = 1'b1;
	
	always @(*)
		begin
		if (doorenable == 1'b1)
		begin
				s1 = 1'b0;		
				s2 = 1'b0;
				s4 = 1'b1;
				s5 = 1'b1;
		end
		else if (doorenable == 1'b0)
		begin
				s1 = 1'b1;		
				s2 = 1'b1;
				s4 = 1'b0;
				s5 = 1'b0;
		end
		end
endmodule

module decoder_left(doorenable, s0, s1, s2, s3, s4, s5, s6);
	
	input doorenable;
	output s0;
	output s1;
	output s2;
	output s3;
	output s4;
	output s5;
	output s6;
	reg s1, s2, s4, s5;
	
	assign s0 = 1'b1;
	assign s3 = 1'b1;
	assign s6 = 1'b1;

	always @(*)
		begin
		if (doorenable == 1'b1)
		begin
				s1 = 1'b1;		
				s2 = 1'b1;
				s4 = 1'b0;
				s5 = 1'b0;
		end
		else if (doorenable == 1'b0)
		begin
				s1 = 1'b0;		
				s2 = 1'b0;
				s4 = 1'b1;
				s5 = 1'b1;
		end
		end
endmodule

module ratedividerdoors(ratedoorenable,clock,reset,q,load);
	//input [27:0] load;
	input [4:0] load;
	input ratedoorenable, clock, reset;
	//output reg [27:0] q;
	output reg [4:0] q;
	
	always @(posedge clock)
	begin
		if (reset == 1'b1)
				q <= load;
		//if (q <= 28'b0000000000000000000000000000)
		if (q <= 5'b00000)
			q <= load;
		else if (ratedoorenable == 1'b1)
				q <= q - 1'b1;
	end
endmodule


module register(d,floorin1, floorin2, reset,clk,q);
	input reset,clk, floorin1, floorin2, d;
	output reg q;
	
	always @(posedge clk)
	begin
	    if (reset == 1'b1)
		     q <= 0;
		 else if (d == 1'b1)
		     q <= d;
		 else if (floorin1 == 1'b1 || floorin2 == 1'b1)
		     q <= 1'b0;
	end
endmodule

module control_master(clock, reset, enable1,enable2,current_floor1,current_floor2,destination1,destination2, idle1, idle2,floor0,floor1,floor2,floor3, move_up1, move_up2, move_down1,move_down2,enable11,enable22);

   input[1:0] current_floor1,current_floor2;
	input floor0, floor1,floor2,floor3, move_up1, move_up2, move_down1,move_down2,enable11,enable22;
	input idle1, idle2, reset, clock;
	output reg enable1, enable2;
   output reg [1:0] destination1, destination2;
	
	
	always@(posedge clock)
	begin
		if (reset == 1'b1)
		   begin
			destination1 <= 2'b00;
			destination2 <= 2'b00;
			enable1 <= 1'b0;
			enable2 <= 1'b0;
			end
		if (floor0 == 1'b1 && (idle1==1'b1 || idle2==1'b1))
		begin
			if (idle1==1'b1 && idle2==1'b1 && current_floor1 == destination1 && current_floor2 == destination2)
			begin
				if(current_floor1 > current_floor2)
				begin
				   enable2 <= 1'b1;
					destination2 <= 2'b00;
				end
				else
				begin
					enable1 <= 1'b1;
					destination1 <= 2'b00;
				end
			end
			else if (idle1 == 1'b1 && destination2 != 2'b00 && current_floor1 == destination1)
				begin
				enable1 <= 1'b1;
				destination1 <=2'b00;
				end
			else if (idle2 == 1'b1 && destination1 != 2'b00 && current_floor2 == destination2)
				begin
				enable2 <= 1'b1;
				destination2 <=2'b00;
				end
			end
		if (floor1 == 1'b1 && (idle1==1'b1 || idle2==1'b1))
		begin
			if (idle1==1'b1 && idle2==1'b1 && current_floor1 == destination1 && current_floor2 == destination2)
			begin
				if(current_floor1 == 2'b01)
				begin
				enable1 <= 1'b1;
				destination1 <= 2'b01;
				end
				else if(current_floor2 == 2'b01)
				begin
				enable2 <= 1'b1;
				destination2 <= 2'b01;
				end
				else if(current_floor1 == 2'b00 || current_floor1 == 2'b10)
				begin
				enable1 <= 1'b1;
				destination1 <= 2'b01;
				end
				else if(current_floor2 == 2'b00 || current_floor2 == 2'b10)
				begin
				enable2 <= 1'b1;
				destination2 <= 2'b01;
				end
			   else
				begin
				enable1 <= 1'b1;
				destination1 <= 2'b01;
				end
			end
			else if (idle1 == 1'b1 && destination2 != 2'b01 && current_floor1 == destination1)
				begin
				enable1 <= 1'b1;
				destination1 <=2'b01;
				end
			else if (idle2 == 1'b1 && destination1 != 2'b01 && current_floor2 == destination2)
				begin
				enable2 <= 1'b1;
				destination2 <=2'b01;
				end
		end
		if (floor2 == 1'b1 && (idle1==1'b1 || idle2==1'b1))
			begin
			if (idle1==1'b1 && idle2==1'b1 && current_floor1 == destination1 && current_floor2 == destination2)
			begin
				if(current_floor1 == 2'b10)
				begin
				enable1 <= 1'b1;
				destination1 <= 2'b10;
				end
				else if(current_floor2 == 2'b10)
				begin
				enable2 <= 1'b1;
				destination2 <= 2'b10;
				end
				else if(current_floor1 == 2'b01 || current_floor1 == 2'b11)
				begin
				enable1 <= 1'b1;
				destination1 <= 2'b10;
				end
				else if(current_floor2 == 2'b01 || current_floor2 == 2'b11)
				begin
				enable2 <= 1'b1;
				destination2 <= 2'b10;
				end
			   else
				begin
				enable1 <= 1'b1;
				destination1 <= 2'b10;
				end
			end
			else if (idle1 == 1'b1 && destination2 != 2'b10 && current_floor1 == destination1)
				begin
				enable1 <= 1'b1;
				destination1 <=2'b10;
				end
			else if (idle2 == 1'b1 && destination1 != 2'b10 && current_floor2 == destination2)
					begin
					enable2 <= 1'b1;
					destination2 <=2'b10;
					end
			end
		if (floor3 == 1'b1 && (idle1==1'b1 || idle2==1'b1))
			begin
			if (idle1==1'b1 && idle2==1'b1 && current_floor1 == destination1 && current_floor2 == destination2)
			begin
				if(current_floor1 > current_floor2)
				begin
				   enable1 <= 1'b1;
					destination1 <= 2'b11;
				end
				else
				begin
					enable2 <= 1'b1;
					destination2 <= 2'b11;
				end
			end
			else if (idle1 == 1'b1 && destination2 != 2'b11 && current_floor1 == destination1)
				begin
				enable1 <= 1'b1;
				destination1 <=2'b11;
				end
			else if (idle2 == 1'b1 && destination1 != 2'b11 && current_floor2 == destination2)
				begin
				enable2 <= 1'b1;
				destination2 <= 2'b11;
				end
			end
		
		if (current_floor1 == destination1 && enable11==1'b1)
			enable1 <= 1'b0;
		if (current_floor2 == destination2 &&enable22==1'b1 )
			enable2 <=1'b0;
			
	end
endmodule


//	always@(*)
//	begin
//		if(current_floor1 < destination && current_floor2 < destination && current_floor1 < current_floor2)
//			control_en2 <= 1'b1;
//		else if(current_floor1 < destination && current_floor2 < destination && current_floor1 > current_floor2)
//			control_en1 <= 1'b1;
//		else if(current_floor1 > destination && current_floor2 > destination && current_floor1 < current_floor2)
//			control_en1 <= 1'b1;
//		else if(current_floor1 > destination && current_floor2 > destination && current_floor1 > current_floor2)
//			control_en2 <= 1'b1;
//		else if(current_floor1 > destination && current_floor2 < destination)
//		begin 
//			if((current_floor1 - destination) > (destination - current_floor2))
//			  control_en2<=1'b1;
//			else
//			  control_en1<=1'b1;
//		end
//		else if(current_floor1 < destination && current_floor2 > destination)
//		begin 
//			if((current_floor2 - destination) > (destination - current_floor1))
//			  control_en1<=1'b1;
//			else
//			  control_en2<=1'b1;
//		end
//  end

