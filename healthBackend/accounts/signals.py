# from django.db.models.signals import post_save
# from django.dispatch import receiver
# from .models import CustomUser, DoctorProfile, ClientProfile

# @receiver(post_save, sender=CustomUser)
# def create_user_profile(sender, instance, created, **kwargs):
#     if created:
#         if instance.role == 'doctor':
#             DoctorProfile.objects.create(user=instance)
#         elif instance.role == 'client':
#             ClientProfile.objects.create(user=instance)