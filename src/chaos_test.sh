# !/bin/bash
echo "Starting Active Session (High-Speed Ping)..."
# Ping 5 times a second (-i 0.2), log dropped packets (-O), and add Unix timestamps (-D)
ping 10.45.0.1 -i 0.2 -O -D > ping_trace.txt &
PING_PID=$!

sleep 5
echo "[Time: 5s] INJECTING FAILURE: Assassinating AMF (Control Plane)"
docker kill amf

sleep 10
echo "[Time: 15s] INJECTING FAILURE: Assassinating SMF (Session Plane)"
docker kill smf

sleep 10
echo "[Time: 25s] INJECTING FAILURE: Assassinating UPF (Data Plane)"
docker kill upf

sleep 15
echo "Ending test. Analyzing auto-recovery..."
kill $PING_PID
