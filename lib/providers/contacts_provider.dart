// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karnova/models/contact.dart';

// Provider for contacts
final contactsProvider = StateNotifierProvider<ContactsNotifier, List<Contact>>((ref) {
  return ContactsNotifier();
});

// Notifier for contacts
class ContactsNotifier extends StateNotifier<List<Contact>> {
  ContactsNotifier() : super(_initialContacts);

  // Add a new contact
  void addContact(Contact contact) {
    state = [...state, contact];
  }

  // Update an existing contact
  void updateContact(Contact updatedContact) {
    state = state.map((contact) {
      return contact.id == updatedContact.id ? updatedContact : contact;
    }).toList();
  }

  // Delete a contact
  void deleteContact(String id) {
    state = state.where((contact) => contact.id != id).toList();
  }

  // Toggle favorite status
  void toggleFavorite(String id) {
    state = state.map((contact) {
      if (contact.id == id) {
        return contact.copyWith(isFavorite: !contact.isFavorite);
      }
      return contact;
    }).toList();
  }

  // Filter contacts by relationship
  List<Contact> getContactsByRelationship(String relationship) {
    return state.where((contact) => contact.relationship == relationship).toList();
  }

  // Get favorite contacts
  List<Contact> getFavoriteContacts() {
    return state.where((contact) => contact.isFavorite).toList();
  }
}

// Initial mock data for contacts
final List<Contact> _initialContacts = [
  Contact(
    id: '1',
    name: 'Sarah Johnson',
    relationship: 'Family',
    email: 'sarah.j@example.com',
    phone: '+1 (555) 123-4567',
    image: 'https://i.pravatar.cc/150?img=5',
    isFavorite: true,
    recentTrips: ['trip1', 'trip3'],
  ),
  Contact(
    id: '2',
    name: 'Michael Chen',
    relationship: 'Friend',
    email: 'michael.c@example.com',
    phone: '+1 (555) 987-6543',
    image: 'https://i.pravatar.cc/150?img=8',
    isFavorite: false,
    recentTrips: ['trip2'],
  ),
  Contact(
    id: '3',
    name: 'Emily Rodriguez',
    relationship: 'Family',
    email: 'emily.r@example.com',
    phone: '+1 (555) 456-7890',
    image: 'https://i.pravatar.cc/150?img=9',
    isFavorite: true,
    recentTrips: [],
  ),
  Contact(
    id: '4',
    name: 'David Kim',
    relationship: 'Friend',
    email: 'david.k@example.com',
    phone: '+1 (555) 789-0123',
    image: 'https://i.pravatar.cc/150?img=12',
    isFavorite: false,
    recentTrips: ['trip1'],
  ),
  Contact(
    id: '5',
    name: 'Jessica Patel',
    relationship: 'Friend',
    email: 'jessica.p@example.com',
    phone: '+1 (555) 234-5678',
    image: 'https://i.pravatar.cc/150?img=20',
    isFavorite: true,
    recentTrips: ['trip3'],
  ),
];
