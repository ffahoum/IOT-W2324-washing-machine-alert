#ifndef HEARTBEAT_H
#define HEARTBEAT_H

/**
 * @file Heartbeat.h
 * @brief Header file for the Heartbeat class.
 */

/**
 * @class Heartbeat
 * @brief Class for managing heartbeat functionality.
 * 
 * The Heartbeat class provides functionality to obtain the current time
 * from an NTP server.
 */
class Heartbeat {
private:
    const char* ntpServer = "pool.ntp.org"; /**< NTP server used for obtaining time. */

public:
    /**
     * @brief Constructs a new Heartbeat object.
     */
    Heartbeat();

    /**
     * @brief Get the current time from the NTP server.
     * @return The current time in milliseconds since the Unix epoch.
     */
    unsigned long getTime();
};

#endif // HEARTBEAT_H
