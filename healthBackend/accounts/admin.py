from django.contrib import admin
from .models import ClientProfile, CustomUser, DoctorProfile

# Register your models here.
admin.site.register(ClientProfile)
admin.site.register(DoctorProfile)
admin.site.register(CustomUser)
