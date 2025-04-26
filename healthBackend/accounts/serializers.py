from rest_framework import serializers

from programs.serializers import ClientProgramSerializer, ProgramSerializer
from .models import ClientProfile, CustomUser, DoctorProfile


class UserRegistrationSerializer(serializers.ModelSerializer):
    age = serializers.IntegerField(write_only=True, required=False)
    specialization = serializers.CharField(write_only=True, required=False)

    class Meta:
        model = CustomUser
        fields = ['username', 'email', 'password', 'role', 'age', 'specialization']
        extra_kwargs = {'password': {'write_only': True}}

    def validate(self, attrs):
        role = attrs.get('role')

        if role == 'client' and 'age' not in attrs:
            raise serializers.ValidationError("Age is required for clients.")
        if role == 'doctor' and 'specialization' not in attrs:
            raise serializers.ValidationError("Specialization is required for doctors.")

        return attrs
    
    
    def create(self, validated_data):
        age = validated_data.pop('age', None)
        specialization = validated_data.pop('specialization', None)
        role = validated_data.get('role')

        user = CustomUser.objects.create_user(**validated_data)
        print(f"User created with role: {role}")

        if role == 'client':
            profile = ClientProfile.objects.create(user=user, age=age)
            print(f"Client profile created: {profile}")
        elif role == 'doctor':
            profile = DoctorProfile.objects.create(user=user, specialty=specialization, license_number="TEMP")
            print(f"Doctor profile created: {profile}")

        return user
    
class ClientProfileSerializer(serializers.ModelSerializer):
    # user_name = serializers.CharField(source='user.get_full_name', read_only=True)
    email = serializers.EmailField(source='user.email', read_only=True)
    programs = ClientProgramSerializer(many=True, read_only=True)

    class Meta:
        model = ClientProfile
        fields = ['id', 'email', 'age', 'gender', 'programs']