from django.db import models

from accounts.models import DoctorProfile, ClientProfile

# Create your models here.
class Program(models.Model):
    name = models.CharField(max_length=100) 
    description = models.TextField(blank=True, null=True) 
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    doctor = models.OneToOneField(DoctorProfile, on_delete=models.CASCADE) 
    clients = models.ManyToManyField(ClientProfile, blank=True, related_name='programs') 
    start_date = models.DateField(blank=True, null=True)
    end_date = models.DateField(blank=True, null=True)

    is_active = models.BooleanField(default=True)

    goals = models.TextField(blank=True, null=True)
    treatment_guidelines = models.TextField(blank=True, null=True)
    location = models.CharField(max_length=100, blank=True, null=True)

    def __str__(self):
        return self.name