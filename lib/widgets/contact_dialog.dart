// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:karnova/models/contact.dart';

class ContactDialog extends ConsumerStatefulWidget {
  final Contact? contact; // Null for adding new contact, non-null for editing

  const ContactDialog({super.key, this.contact});

  @override
  ConsumerState<ContactDialog> createState() => _ContactDialogState();
}

class _ContactDialogState extends ConsumerState<ContactDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  String _relationship = 'Friend';
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data if editing
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
    _emailController = TextEditingController(text: widget.contact?.email ?? '');
    _phoneController = TextEditingController(text: widget.contact?.phone ?? '');
    _relationship = widget.contact?.relationship ?? 'Friend';
    _isFavorite = widget.contact?.isFavorite ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.contact != null;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        padding: EdgeInsets.all(16.w),
        width: 350.w,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dialog title
              Text(
                isEditing ? 'Edit Contact' : 'Add New Contact',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.h),

              // Name field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.h),

              // Email field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.h),

              // Phone field
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // Relationship selection
              Text(
                'Relationship',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  _buildRelationshipChip('Family'),
                  SizedBox(width: 8.w),
                  _buildRelationshipChip('Friend'),
                  SizedBox(width: 8.w),
                  _buildRelationshipChip('Colleague'),
                ],
              ),
              SizedBox(height: 16.h),

              // Favorite toggle
              Row(
                children: [
                  Checkbox(
                    value: _isFavorite,
                    onChanged: (value) {
                      setState(() {
                        _isFavorite = value ?? false;
                      });
                    },
                    activeColor: Colors.blue[300],
                  ),
                  Text(
                    'Add to favorites',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white70,
                    ),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: _saveContact,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(isEditing ? 'Update' : 'Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRelationshipChip(String relationship) {
    final isSelected = _relationship == relationship;
    
    return ChoiceChip(
      label: Text(relationship),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _relationship = relationship;
          });
        }
      },
      backgroundColor: Colors.grey[800],
      selectedColor: Colors.blue[700],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.white70,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      final contact = Contact(
        id: widget.contact?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        relationship: _relationship,
        email: _emailController.text,
        phone: _phoneController.text,
        image: widget.contact?.image ?? 'https://i.pravatar.cc/150?img=${(DateTime.now().millisecondsSinceEpoch % 70) + 1}',
        isFavorite: _isFavorite,
        recentTrips: widget.contact?.recentTrips ?? [],
      );
      
      Navigator.pop(context, contact);
    }
  }
}
