from rest_framework import serializers

class emailserializer(serializers.ModelSerializer): # Serializer for the CustomUser model
    class Meta:
        fields = ('id', 'username', 'email', 'password', 'is_teacher', 'is_student')
