# Create a simulator object
set ns [new Simulator]

# Open the nam trace file
set nf [open out.nam w]
$ns namtrace-all $nf

# Define a 'finish' procedure
proc finish {} {
    global ns nf
    $ns flush-trace
    # Close the trace file
    close $nf
    # Execute nam on the trace file
    exec nam out.nam &
    exit 0
}

# Create six nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

# Create links between the central node and other nodes to form a Star Topology
$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n0 $n2 1Mb 10ms DropTail
$ns duplex-link $n0 $n3 1Mb 10ms DropTail
$ns duplex-link $n0 $n4 1Mb 10ms DropTail
$ns duplex-link $n0 $n5 1Mb 10ms DropTail

# Create a TCP agent and attach it to node n1
set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1

# Create a TCP Sink agent (a traffic sink) for TCP and attach it to node n5
set sink1 [new Agent/TCPSink]
$ns attach-agent $n5 $sink1

# Connect the traffic sources with the traffic sink
$ns connect $tcp1 $sink1

# Create a CBR traffic source and attach it to tcp1
set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.01
$cbr1 attach-agent $tcp1

# Schedule events for the CBR agents
$ns at 0.5 "$cbr1 start"
$ns at 4.5 "$cbr1 stop"

# Call the finish procedure after 5 seconds of simulation time
$ns at 5.0 "finish"

# Run the simulation
$ns run
