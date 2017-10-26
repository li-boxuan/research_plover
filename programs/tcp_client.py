#!/usr/bin/python
import socket
import sys
import time, threading
port = 9999
ip = str(sys.argv[1])
def send_and_receive():
	print 'thread %s is running...' % threading.current_thread().name
	# Create a TCP/IP socket
	sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	
	# Connect the socket to the port where the server is listening
	server_address = (ip, port)
	print >>sys.stderr, 'connecting to %s port %s' % server_address
	sock.connect(server_address)
	#time.sleep(3)
	try:
	    for request in range(5):	    
		    #Send data
		    message = ""
		    for i in range(1000):
		    	message += '+PONG\r\n'
		    #print >>sys.stderr, 'sending "%s"' % message
		    sock.sendall(message)
		
		    # Look for the response
		    amount_received = 0
		    amount_expected = len(message)
		    while amount_received < amount_expected:
		        data = sock.recv(1024 * 16)
		        amount_received += len(data)
		        #print >>sys.stderr, 'received "%s"' % data
			if amount_received % 1000 == 0:
			    print 'thread %s received length %d' % (threading.current_thread().name, len(data))
	
	finally:
	    print >>sys.stderr, 'closing socket'
	    sock.close()
	print 'thread %s ended.' % threading.current_thread().name

thread_list = []
for i in range(20):
	thread_name = 'Thread ' + str(i)
	t = threading.Thread(target=send_and_receive, name=thread_name)
	t.start()
	thread_list.append(t)

for t in thread_list:
	t.join()
