import 'package:flutter/material.dart';

class PendingApplicationsScreen extends StatelessWidget {
  const PendingApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF111111),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(25),
            child: Row(
              children: [
                //SidebarMenu(),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tenant Management',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Manage your tenants or invite new tenants to your residence',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFFA9A9A9),
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: 1860,
                                height: 922,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF282828),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(25),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          // Back Button
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                                onPressed: () {
                                                  Navigator.pop(context); // This will go back to the previous screen
                                                },
                                              ),
                                              const SizedBox(width: 8),
                                              const Text(
                                                "Back",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),

                                          // Title
                                          const Text(
                                            "Pending Applications",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 20),

                                          // Search + Filter Row
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                    EdgeInsets.all(8),
                                                    hintText:
                                                    'Search by chats and people',
                                                    filled: true,
                                                    fillColor: Colors.grey[900],
                                                    prefixIcon: const Icon(
                                                        Icons.search,
                                                        color: Colors.white),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(8),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    hintStyle: const TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              ElevatedButton.icon(
                                                onPressed: () {},
                                                icon: const Icon(Icons.filter_list),
                                                label: const Text("Filter"),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.grey[800],
                                                  foregroundColor: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 24),

                                          // Table Header
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Expanded(
                                                  child: Text("Name",
                                                      style: TextStyle(
                                                          color: Colors.white))),
                                              Expanded(
                                                  child: Text("Email",
                                                      style: TextStyle(
                                                          color: Colors.white))),
                                              Expanded(
                                                  child: Text("Phone Number",
                                                      style: TextStyle(
                                                          color: Colors.white))),
                                              Expanded(
                                                  child: Text("Unit No.",
                                                      style: TextStyle(
                                                          color: Colors.white))),
                                              Expanded(
                                                  child: Text("Move-in Date",
                                                      style: TextStyle(
                                                          color: Colors.white))),
                                              Expanded(
                                                  child: Text("Actions",
                                                      style: TextStyle(
                                                          color: Colors.white))),
                                            ],
                                          ),
                                          const Divider(color: Colors.grey),

                                          // Table Rows (Repeat this Row for each entry)
                                          ...List.generate(6, (index) {
                                            return Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                        child: Text("Ralph Edwards",
                                                            style: TextStyle(
                                                                color:
                                                                Colors.white))),
                                                    Expanded(
                                                        child: Text(
                                                            "ralphedwards@gmail.com",
                                                            style: TextStyle(
                                                                color:
                                                                Colors.white))),
                                                    Expanded(
                                                        child: Text("0912345678",
                                                            style: TextStyle(
                                                                color:
                                                                Colors.white))),
                                                    Expanded(
                                                        child: Text("101",
                                                            style: TextStyle(
                                                                color:
                                                                Colors.white))),
                                                    Expanded(
                                                        child: Text(
                                                            "January 12, 2025",
                                                            style: TextStyle(
                                                                color:
                                                                Colors.white))),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          ElevatedButton(
                                                            onPressed: () {},
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                backgroundColor:
                                                                Colors
                                                                    .green),
                                                            child: const Text(
                                                                "Approve",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          ElevatedButton(
                                                            onPressed: () {},
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                backgroundColor:
                                                                Colors.red
                                                                    .shade900),
                                                            child: const Text(
                                                                "Decline",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Divider(
                                                    color: Color(0xFF454343)),
                                              ],
                                            );
                                          }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        )
                      ],
                    ))
              ],
            )),
      ),
    );
  }
}
