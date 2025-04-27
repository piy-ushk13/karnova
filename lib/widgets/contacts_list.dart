// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:karnova/models/contact.dart';
import 'package:karnova/providers/contacts_provider.dart';
import 'package:karnova/widgets/contact_dialog.dart';

class ContactsList extends ConsumerStatefulWidget {
  const ContactsList({super.key});

  @override
  ConsumerState<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends ConsumerState<ContactsList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Filter contacts based on search query and relationship
  List<Contact> _getFilteredContacts(
    List<Contact> contacts,
    String relationship,
  ) {
    if (relationship == 'All') {
      return contacts
          .where(
            (contact) =>
                contact.name.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                contact.email.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                contact.phone.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }

    return contacts
        .where(
          (contact) =>
              contact.relationship == relationship &&
              (contact.name.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
                  contact.email.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
                  contact.phone.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  )),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final contacts = ref.watch(contactsProvider);

    return Column(
      children: [
        // Search bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search contacts',
              prefixIcon: const Icon(Icons.search),
              suffixIcon:
                  _searchQuery.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 12.h),
            ),
          ),
        ),

        // Tab bar for filtering by relationship
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Family'),
            Tab(text: 'Friend'),
          ],
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).colorScheme.primary,
        ),

        // Add contact button
        Padding(
          padding: EdgeInsets.all(16.w),
          child: ElevatedButton.icon(
            onPressed: () => _showAddContactDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Contact'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 48.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),

        // Contacts list
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // All contacts
              _buildContactsList(_getFilteredContacts(contacts, 'All')),
              // Family contacts
              _buildContactsList(_getFilteredContacts(contacts, 'Family')),
              // Friend contacts
              _buildContactsList(_getFilteredContacts(contacts, 'Friend')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactsList(List<Contact> contacts) {
    if (contacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64.sp, color: Colors.grey[400]),
            SizedBox(height: 16.h),
            Text(
              'No contacts found',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try a different search term'
                  : 'Add contacts to see them here',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return _buildContactCard(contact);
      },
    );
  }

  Widget _buildContactCard(Contact contact) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      color: Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.all(12.w),
        leading: CircleAvatar(
          radius: 24.r,
          backgroundImage: NetworkImage(
            contact.image ?? 'https://i.pravatar.cc/150?img=1',
          ),
          backgroundColor: Colors.grey[300],
        ),
        title: Text(
          contact.name,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(Icons.people, size: 14.sp, color: Colors.grey[600]),
                SizedBox(width: 4.w),
                Text(
                  contact.relationship,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Icon(Icons.email, size: 14.sp, color: Colors.grey[600]),
                SizedBox(width: 4.w),
                Text(
                  contact.email,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Icon(Icons.phone, size: 14.sp, color: Colors.grey[600]),
                SizedBox(width: 4.w),
                Text(
                  contact.phone,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                contact.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: contact.isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                ref.read(contactsProvider.notifier).toggleFavorite(contact.id);
              },
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'edit') {
                  _showEditContactDialog(context, contact);
                } else if (value == 'delete') {
                  _showDeleteConfirmation(context, contact);
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text('Edit', style: TextStyle(color: Colors.black87)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) async {
    final contact = await showDialog<Contact>(
      context: context,
      builder: (context) => const ContactDialog(),
    );

    if (contact != null) {
      ref.read(contactsProvider.notifier).addContact(contact);
    }
  }

  void _showEditContactDialog(BuildContext context, Contact contact) async {
    final updatedContact = await showDialog<Contact>(
      context: context,
      builder: (context) => ContactDialog(contact: contact),
    );

    if (updatedContact != null) {
      ref.read(contactsProvider.notifier).updateContact(updatedContact);
    }
  }

  void _showDeleteConfirmation(BuildContext context, Contact contact) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Delete Contact',
              style: TextStyle(color: Colors.black),
            ),
            content: Text(
              'Are you sure you want to delete ${contact.name}?',
              style: const TextStyle(color: Colors.black87),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.read(contactsProvider.notifier).deleteContact(contact.id);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
