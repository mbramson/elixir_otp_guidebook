defmodule CacheTest do
  use ExUnit.Case
  doctest Cache

  setup do
    {:ok, cache_pid} = Cache.start_link
    {:ok, [cache_pid: cache_pid]}
  end

  describe "write/2" do
    test "writes to the cache" do
      Cache.write("cat", "dog")
      assert Cache.read("cat") == "dog"
    end

    test "overwrites previous cache value" do
      Cache.write("cat", "dog")
      Cache.write("cat", "frog")
      assert Cache.read("cat") == "frog"
    end
  end

  describe "read/1" do
    test "returns the value in the cache" do
      Cache.write("cat", "dog")
      assert Cache.read("cat") == "dog"
    end

    test "returns an error tuple if value not in cache" do
      assert Cache.read("cat") == {:error, :no_value}
    end
  end

  describe "delete/1" do
    test "deletes a key from the cache" do
      Cache.write("cat", "dog")
      Cache.delete("cat")
      assert Cache.read("cat") == {:error, :no_value}
    end

    test "doesnt delete other keys from the cache" do
      Cache.write("cat", "dog")
      Cache.write("pig", "fly")
      Cache.delete("cat")
      assert Cache.read("pig") == "fly"
    end

    test "can delete a key that doesn't exist" do
      assert Cache.delete("cat") == :ok
    end
  end

  describe "clear/0" do
    test "deletes all keys from the cache" do
      Cache.write("cat", "dog")
      Cache.write("pig", "fly")
      Cache.clear
      assert Cache.read("cat") == {:error, :no_value}
      assert Cache.read("pig") == {:error, :no_value}
    end

    test "can clear when there are no keys in cache" do
      assert Cache.clear == :ok
    end
  end

  describe "exist?/1" do
    test "is true when key exists" do
      Cache.write("cat", "dog")
      assert Cache.exist?("cat") == true
    end

    test "is false when key does not exist" do
      assert Cache.exist?("cat") == false
    end
  end

  describe "key_count/0" do
    test "is 0 when no keys exist" do
      assert Cache.key_count == 0
    end

    test "returns the number of keys" do
      Cache.write("cat", "dog")
      Cache.write("pig", "fly")
      assert Cache.key_count == 2
    end

    test "doesnt double count per overwritten cache insertion" do
      Cache.write("cat", "dog")
      Cache.write("cat", "dog")
      assert Cache.key_count == 1
    end
  end

  describe "stop/0" do
    test "stops the process", %{cache_pid: cache_pid} do
      Cache.stop
      Process.sleep(20) # :(
      refute Process.alive? cache_pid
    end
  end
end
